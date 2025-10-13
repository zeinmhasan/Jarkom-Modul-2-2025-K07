Tirion (ns1 / master)
apt-get update
apt-get install -y bind9 bind9-utils dnsutils || true

mkdir -p /etc/bind/zones /var/cache/bind /run/named
id bind 2>/dev/null || useradd -r -s /usr/sbin/nologin bind || true
chown -R bind:bind /etc/bind /var/cache/bind /run/named

DOMAIN="zein.com"     # <== GANTI sesuai soal
NS1="10.67.3.3"         # Tirion
NS2="10.67.3.4"         # Valmar
APEX="10.67.3.2"        # Sirion
SERIAL="$(date +%Y%m%d)01"

cat >/etc/bind/named.conf.options <<EOF
options {
    directory "/var/cache/bind";
    recursion yes;
    allow-recursion { any; };
    dnssec-validation no;
    forwarders { 192.168.122.1; };
    listen-on { any; };
    listen-on-v6 { any; };
};
EOF

cat >/etc/bind/named.conf.local <<EOF
zone "$DOMAIN" {
    type master;
    file "/etc/bind/zones/db-$DOMAIN";
    notify yes;
    also-notify { $NS2; };        // Valmar
    allow-transfer { $NS2; };     // izinkan AXFR ke ns2
};
EOF

cat >/etc/bind/zones/db-$DOMAIN <<EOF
\$TTL 300
@   IN SOA  ns1.$DOMAIN. admin.$DOMAIN. (
        $SERIAL   ; Serial
        3600      ; Refresh
        900       ; Retry
        1209600   ; Expire
        300 )     ; Minimum

; Authoritative nameservers
    IN NS   ns1.$DOMAIN.
    IN NS   ns2.$DOMAIN.

; Host records untuk NS
ns1 IN A $NS1
ns2 IN A $NS2

; Apex mengarah ke front door (Sirion)
@   IN A $APEX

; Contoh tambahan (opsional)
; www IN CNAME @
; api IN A $APEX
EOF

named-checkconf
named-checkzone "$DOMAIN" /etc/bind/zones/db-$DOMAIN

# jalankan foreground (lihat log di console ini)
#/usr/sbin/named -4 -u bind -c /etc/bind/named.conf -g

# atau jalankan di background:
 /usr/sbin/named -4 -u bind -c /etc/bind/named.conf

Valmar (ns2 / slave)
apt-get update
apt-get install -y bind9 bind9-utils dnsutils || true

mkdir -p /var/cache/bind /run/named
id bind 2>/dev/null || useradd -r -s /usr/sbin/nologin bind || true
chown -R bind:bind /etc/bind /var/cache/bind /run/named

DOMAIN="zein.com"     # <== GANTI sama persis
NS1="10.67.3.3"
NS2="10.67.3.4"

cat >/etc/bind/named.conf.options <<EOF
options {
    directory "/var/cache/bind";
    recursion yes;
    allow-recursion { any; };
    dnssec-validation no;
    forwarders { 192.168.122.1; };
    listen-on { any; };
    listen-on-v6 { any; };
};
EOF

cat >/etc/bind/named.conf.local <<EOF
zone "$DOMAIN" {
    type slave;
    masters { $NS1; };                    // Tirion
    file "/var/cache/bind/$DOMAIN.slave";
    allow-notify { $NS1; };
};
EOF

named-checkconf
 /usr/sbin/named -4 -u bind -c /etc/bind/named.conf
# setelah hidup, harus otomatis AXFR dan membuat /var/cache/bind/$DOMAIN.slave

Jalankan di Earendil, Elwing, Cirdan, Elrond, Maglor (dan boleh di Sirion juga).
DOMAIN="zein.com"   # opsional, kalau mau pakai 'search'

rm -f /etc/resolv.conf
cat >/etc/resolv.conf <<EOF
nameserver 10.67.3.3   # ns1 (Tirion)
nameserver 10.67.3.4   # ns2 (Valmar)
nameserver 192.168.122.1
# search $DOMAIN
EOF

# opsional: kunci agar tidak ditimpa
chattr +i /etc/resolv.conf 2>/dev/null || true

Cek authoritative (AA) di ns1 & ns2
dig @10.67.3.3 $DOMAIN A +norecurse +noall +answer +authority +comments
dig @10.67.3.4 $DOMAIN A +norecurse +noall +answer +authority +comments
# Harus ada "flags: aa" dan jawaban A $APEX (10.67.3.2)

Cek NS & host NS:
dig @10.67.3.3 $DOMAIN NS +norecurse +noall +answer
dig @10.67.3.3 ns1.$DOMAIN A +noall +answer
dig @10.67.3.3 ns2.$DOMAIN A +noall +answer

Cek transfer zona (AXFR) ke ns2
dig @10.67.3.4 $DOMAIN AXFR

Cek dari klien (pakai resolv.conf urutan ns1→ns2→forwarder)
dig $DOMAIN A +noall +answer
dig ns1.$DOMAIN A +noall +answer
dig ns2.$DOMAIN A +noall +answer
