# di lindon
apt-get update
apt-get install -y nginx

# direktori web
mkdir -p /var/www/static/annals
echo "Hello from static.zein.com" > /var/www/static/index.html

# contoh isi arsip (biar terlihat di listing)
echo "chronicle-1" > /var/www/static/annals/1.txt
echo "chronicle-2" > /var/www/static/annals/2.txt

cat >/etc/nginx/sites-available/static.zein.com <<'EOF'
server {
    listen 80;
    server_name static.zein.com;

    root /var/www/static;
    index index.html;

    # Autoindex untuk folder /annals/
    location /annals/ {
        autoindex on;
        autoindex_exact_size off;
        autoindex_localtime on;
    }

    # (opsional) cegah directory listing selain di /annals/
    location / {
        # index sudah ada; jika tidak ada index, tetap 403 (tanpa autoindex)
    }
}
EOF

# default server: tolak semua request yg tidak pakai hostname kita (akses via IP)
cat >/etc/nginx/sites-available/000-default-deny <<'EOF'
server {
    listen 80 default_server;
    server_name _;

    # drop cepat; bisa juga return 404 kalau kamu mau
    return 444;
}
EOF

ln -sf /etc/nginx/sites-available/static.zein.com /etc/nginx/sites-enabled/static.zein.com
ln -sf /etc/nginx/sites-available/000-default-deny /etc/nginx/sites-enabled/000-default-deny

# matikan default bawaan nginx jika ada
rm -f /etc/nginx/sites-enabled/default 2>/dev/null || true

nginx -t && nginx -s reload || systemctl reload nginx 2>/dev/null || service nginx reload 2>/dev/null

# 1) bersihkan pidfile kosong & start fresh
rm -f /run/nginx.pid /var/run/nginx.pid 2>/dev/null || true
nginx -t
nginx                       # start daemon (tanpa systemd)

# 2) kalau mau paksa reload setelah perubahan
nginx -s reload 2>/dev/null || true

# 3) verifikasi proses & port
ps aux | grep '[n]ginx'
ss -lntp | grep ':80 '

sed -n '1,120p' /etc/nginx/sites-available/static.zein.com

# di earendil
dig +short static.zein.com
