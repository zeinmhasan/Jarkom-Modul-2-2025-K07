# ===== di TIRION (ns1) =====
DOMAIN="k07.com"
REVZONE="3.67.10.in-addr.arpa"
ZONEFILE="/etc/bind/zones/db-$REVZONE"

mkdir -p /etc/bind/zones

# Tambah deklarasi zona reverse (master) dengan notify & transfer ke ns2
cat >> /etc/bind/named.conf.local <<EOF

zone "$REVZONE" {
    type master;
    file "$ZONEFILE";
    notify yes;
    also-notify { 10.67.3.4; };    // ns2 (Valmar)
    allow-transfer { 10.67.3.4; }; // izinkan AXFR ke ns2
};
EOF

# Buat file zona reverse dengan PTR untuk DMZ hosts
SERIAL="$(date +%Y%m%d)01"
cat > "$ZONEFILE" <<EOF
\$TTL 300
@   IN SOA  ns1.$DOMAIN. admin.$DOMAIN. (
        $SERIAL   ; Serial
        3600      ; Refresh
        900       ; Retry
        1209600   ; Expire
        300 )     ; Minimum

    IN NS  ns1.$DOMAIN.
    IN NS  ns2.$DOMAIN.

; Host octet -> PTR
2   IN PTR sirion.$DOMAIN.
5   IN PTR lindon.$DOMAIN.
6   IN PTR vingilot.$DOMAIN.
EOF

# Validasi & muat ulang named
named-checkzone "$REVZONE" "$ZONEFILE"
kill -HUP "$(cat /run/named/named.pid)" 2>/dev/null || true
# (opsional) beritahu slave
rndc notify "$REVZONE" 2>/dev/null || true

# ===== di VALMAR (ns2) =====
REVZONE="3.67.10.in-addr.arpa"

# Deklarasi zona slave
cat >> /etc/bind/named.conf.local <<EOF

zone "$REVZONE" {
    type slave;
    masters { 10.67.3.3; };                 // ns1 (Tirion)
    file "/var/cache/bind/$REVZONE.slave";
    allow-notify { 10.67.3.3; };
    // (opsional lab) allow-transfer { 127.0.0.1; 10.67.3.0/24; };
};
EOF

named-checkconf
# reload/ start named
kill -HUP "$(cat /run/named/named.pid)" 2>/dev/null || \
{ pkill named 2>/dev/null; /usr/sbin/named -4 -u bind -c /etc/bind/named.conf; }

# (opsional) paksa retransfer
rndc retransfer "$REVZONE" 2>/dev/null || true

# di Earendil
for ip in 10.67.3.2 10.67.3.5 10.67.3.6; do
  echo "== -x $ip"
  dig -x "$ip" +short
done

# di Cirdan
for ip in 10.67.3.2 10.67.3.5 10.67.3.6; do
  echo "== -x $ip"
  dig -x "$ip" +short
done
