# di lindon

set -e
apt-get update
apt-get install -y nginx

# Konten statis
mkdir -p /var/www/static/annals
echo "Hello from Lindon (static)" > /var/www/static/index.html
echo "chronicle-1" > /var/www/static/annals/1.txt
echo "chronicle-2" > /var/www/static/annals/2.txt

# Vhost: terima Host dari Sirion (Host akan diteruskan apa adanya)
cat >/etc/nginx/sites-available/static.k07.com <<'NGINX'
server {
    listen 80;
    server_name static.k07.com www.k07.com sirion.k07.com;

    root /var/www/static;
    index index.html;

    # Autoindex khusus untuk /annals/
    location /annals/ {
        autoindex on;
        autoindex_exact_size off;
        autoindex_localtime on;
    }
}
NGINX

ln -sf /etc/nginx/sites-available/static.k07.com /etc/nginx/sites-enabled/static.k07.com
rm -f /etc/nginx/sites-enabled/default 2>/dev/null || true
rm -f /run/nginx.pid /var/run/nginx.pid 2>/dev/null || true

nginx -t
(nginx -s reload 2>/dev/null || nginx)

# Cek listen :80
ss -lntp | grep ':80 ' || echo "WARNING: nginx belum listen di :80"

# di vingilot
set -e
apt-get update
apt-get install -y nginx php-fpm

# Pastikan FPM listen TCP 127.0.0.1:9000
PHPV=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;' 2>/dev/null || true)
[ -z "$PHPV" ] && PHPV=$(ls /etc/php/ | sort -V | tail -n1)
FPM_CONF="/etc/php/${PHPV}/fpm/pool.d/www.conf"
sed -i 's|^listen = .*|listen = 127.0.0.1:9000|' "$FPM_CONF"
if grep -q '^;*listen.allowed_clients' "$FPM_CONF"; then
  sed -i 's|^;*listen.allowed_clients =.*|listen.allowed_clients = 127.0.0.1|' "$FPM_CONF"
else
  echo 'listen.allowed_clients = 127.0.0.1' >> "$FPM_CONF"
fi
systemctl restart php${PHPV}-fpm 2>/dev/null || service php${PHPV}-fpm restart

# Konten dinamis
mkdir -p /var/www/app
cat >/var/www/app/index.php <<'PHP'
<?php
header('Content-Type: text/plain');
echo "Welcome to app.k07.com (home)\n";
echo "Try /about\n";
?>
PHP
cat >/var/www/app/about.php <<'PHP'
<?php
header('Content-Type: text/plain');
echo "About: This is Vingilot (dynamic PHP)\n";
?>
PHP

# Vhost: terima Host dari Sirion (kita teruskan Host apa adanya)
cat >/etc/nginx/sites-available/app.k07.com <<'NGINX'
# Tolak akses via IP (default server)
server {
    listen 80 default_server;
    server_name _;
    return 444;
}

# App dinamis (terima juga www/sirion jika diteruskan dari RP)
server {
    listen 80;
    server_name app.k07.com www.k07.com sirion.k07.com;

    root /var/www/app;
    index index.php;

    # /about -> about.php (tanpa .php)
    location / {
        try_files $uri $uri/ /$uri.php?$args /index.php?$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass 127.0.0.1:9000;
    }

    location ~ /\.(?!well-known) { deny all; }
}
NGINX

ln -sf /etc/nginx/sites-available/app.k07.com /etc/nginx/sites-enabled/app.k07.com
rm -f /etc/nginx/sites-enabled/default 2>/dev/null || true
rm -f /run/nginx.pid /var/run/nginx.pid 2>/dev/null || true

nginx -t
(nginx -s reload 2>/dev/null || nginx)

# Listener check
echo "Listeners:"
ss -lntp | grep -E '(:80|:9000)' || true

# di sirion
set -e
apt-get update
apt-get install -y nginx

DOMAIN="k07.com"
LINDON_IP="10.67.3.5"
VINGILOT_IP="10.67.3.6"

cat >/etc/nginx/sites-available/rp.${DOMAIN} <<EOF
# Tolak akses via IP
server {
    listen 80 default_server;
    server_name _;
    return 444;
}

# Reverse proxy utk www.${DOMAIN} & sirion.${DOMAIN}
server {
    listen 80;
    server_name www.${DOMAIN} sirion.${DOMAIN};

    # Health text
    location = / {
        return 200 "Sirion reverse proxy OK\\n";
        add_header Content-Type text/plain;
    }

    # /static -> Lindon (hapus prefix /static/)
    location /static/ {
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_http_version 1.1;
        proxy_pass http://${LINDON_IP}/;
    }

    # /app -> Vingilot (hapus prefix /app/)
    location /app/ {
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_http_version 1.1;
        proxy_pass http://${VINGILOT_IP}/;
    }
}
EOF

ln -sf /etc/nginx/sites-available/rp.${DOMAIN} /etc/nginx/sites-enabled/rp.${DOMAIN}
rm -f /etc/nginx/sites-enabled/default 2>/dev/null || true
rm -f /run/nginx.pid /var/run/nginx.pid 2>/dev/null || true

nginx -t
(nginx -s reload 2>/dev/null || nginx)

# di earendil
# DNS ke Sirion
dig +short www.k07.com        # -> 10.67.3.2
dig +short sirion.k07.com     # -> 10.67.3.2

# /static via Sirion → Lindon
curl -sI http://www.k07.com/static/ | head -n1
curl -s  http://www.k07.com/static/annals/ | grep -E '1.txt|2.txt'

# /app via Sirion → Vingilot
curl -sI http://www.k07.com/app/ | head -n1
curl -s  http://www.k07.com/app/about | sed -n '1,2p'

# Akses IP Sirion harus bukan 200 (host-only)
curl -sI http://10.67.3.2/ | head -n1


