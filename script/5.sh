# di Tirion (ns1)
ZONE=/etc/bind/zones/db-k07.com
SERIAL=$(date +%Y%m%d)01

# Naikkan serial (jika mau manual, buka file & edit baris SOA)
sed -i "s/^[[:space:]]*[0-9]\{10\}[[:space:]]*; Serial.*/        $SERIAL   ; Serial/" "$ZONE"

# Tambahkan host records (hapus baris yang dobel jika sudah ada)
cat >>"$ZONE" <<'EOF'

; ==== Host records per node ====
; Nameserver hosts (sudah ada di file lama, biarkan / perbarui jika perlu)
; ns1 IN A 10.67.3.3     ; Tirion
; ns2 IN A 10.67.3.4     ; Valmar

; Apex sudah mengarah ke Sirion (10.67.3.2) via "@ IN A 10.67.3.2"
; tambahkan juga label host 'sirion' agar konsisten
sirion      IN A 10.67.3.2

; Barat (LAN-1)
earendil    IN A 10.67.1.2
elwing      IN A 10.67.1.3

; Timur (LAN-2)
cirdan      IN A 10.67.2.2
elrond      IN A 10.67.2.3
maglor      IN A 10.67.2.4

; Selatan (LAN-3 selain ns1/ns2/sirion)
linton      IN A 10.67.3.5
vingilot   IN A 10.67.3.6

; Pengecualian ns1 & ns2:
; Tirion dan Valmar bertanggung jawab sbg NS — gunakan nama ns1/ns2.
; Jika ingin alias nama aslinya tetap dikenal, buat CNAME berikut (opsional)
tirion      IN CNAME ns1
valmar      IN CNAME ns2

EOF

# Cek zona & reload ns1
named-checkzone k07.com "$ZONE"
# Jika OK:
kill -HUP $(cat /run/named/named.pid) 2>/dev/null || rndc reload k07.com

# di Valmar (ns2)
dig @10.67.3.4 k07.com AXFR | egrep 'IN[[:space:]]+(A|NS|SOA|CNAME)' | sed -E 's/[[:space:]]+/ /g' | sort
# Harus terlihat semua A/CNAME baru (earendil, elwing, cirdan, elrond, maglor, sirion, linton, ns1, ns2, dll)

# di earendil
# set short hostname
echo earendil > /etc/hostname
hostname earendil

# /etc/hosts - tambahkan baris 127.0.1.1 untuk FQDN & shortname
grep -q '127.0.1.1 earendil.k07.com earendil' /etc/hosts || \
echo '127.0.1.1 earendil.k07.com earendil' >> /etc/hosts

# pastikan resolv.conf punya search domain (kalau belum)
grep -q '^search k07.com' /etc/resolv.conf || \
{ sed -i '1i search k07.com' /etc/resolv.conf 2>/dev/null || true; }

# verifikasi
hostname -f          # -> earendil.k07.com
getent hosts earendil
getent hosts earendil.k07.com

Tirion (ns1):

echo ns1 > /etc/hostname
hostname ns1
grep -q '127.0.1.1 ns1.k07.com ns1' /etc/hosts || \
echo '127.0.1.1 ns1.k07.com ns1' >> /etc/hosts
hostname -f   # -> ns1.k07.com

Valmar (ns2):

echo ns2 > /etc/hostname
hostname ns2
grep -q '127.0.1.1 ns2.k07.com ns2' /etc/hosts || \
echo '127.0.1.1 ns2.k07.com ns2' >> /etc/hosts
hostname -f   # -> ns2.k07.com

# di earendil
sudo bash -c 'cat > /etc/resolv.conf' <<'EOF'
search k07.com
nameserver 10.67.3.3   # ns1 (Tirion)
nameserver 10.67.3.4   # ns2 (Valmar)
nameserver 192.168.122.1
EOF

# 1) Short name harus auto jadi FQDN via 'search'
getent hosts earendil
getent hosts cirdan
ping -c1 elrond

# 2) FQDN tetap resolv
dig earendil.k07.com +short
dig ns1.k07.com +short

# 3) Lihat urutan resolver sedang dipakai
cat /etc/resolv.conf
