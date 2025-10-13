# ====== di TIRION (ns1) ======
DOMAIN="zein.com"
ZONE="/etc/bind/zones/db-$DOMAIN"

# IP sesuai glosarium (ganti jika berbeda)
SIRION_IP="10.67.3.2"
LINDON_IP="10.67.3.5"     # <- ganti bila IP Lindon beda
VINGILOT_IP="10.67.3.6"   # <- ganti bila IP Vingilot beda

# Naikkan serial SOA (YYYYMMDDnn)
SERIAL="$(date +%Y%m%d)01"
sed -i "0,/; Serial/{s/^[[:space:]]*[0-9]\{10\}[[:space:]]*; Serial.*/        $SERIAL   ; Serial/}" "$ZONE"

# Tambahkan/refresh blok host & CNAME
cat >>"$ZONE" <<EOF

; ==== Web front/backends ====
sirion      IN A $SIRION_IP
lindon      IN A $LINDON_IP
vingilot    IN A $VINGILOT_IP

; ==== Aliases ====
www         IN CNAME sirion.$DOMAIN.
static      IN CNAME lindon.$DOMAIN.
app         IN CNAME vingilot.$DOMAIN.
EOF

# Validasi & reload ns1
named-checkzone "$DOMAIN" "$ZONE"
kill -HUP "$(cat /run/named/named.pid)" 2>/dev/null || true
# (opsional) kirim NOTIFY ke ns2
rndc notify "$DOMAIN" 2>/dev/null || true

1) Cek resolv.conf urutannya di Cirdan
cat >/etc/resolv.conf <<'EOF'
search zein.com
nameserver 10.67.3.3
nameserver 10.67.3.4
nameserver 192.168.122.1
EOF
chattr +i /etc/resolv.conf 2>/dev/null || true

Jalankan di keduanya (Earendil & Cirdan):

for h in sirion lindon vingilot www static app; do
  echo "== $h.zein.com"
  dig +short "$h.zein.com"
done
