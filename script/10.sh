# ===== RUN ON VINGILOT =====
set -e

DOMAIN="k07.com"
APP_HOST="app.${DOMAIN}"

apt-get update
apt-get install -y nginx php-fpm

# -- Deteksi versi PHP & set PHP-FPM listen di TCP 127.0.0.1:9000 --
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

# -- Konten aplikasi --
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

# -- Vhost Nginx: host-only, rewrite /about tanpa .php --
cat >/etc/nginx/sites-available/${APP_HOST} <<NGINX
# Tolak akses via IP
server {
    listen 80 default_server;
    server_name _;
    return 444;
}

# Aplikasi dinamis di app.k07.com
server {
    listen 80;
    server_name ${APP_HOST};

    root /var/www/app;
    index index.php;

    # Pretty URL: /about -> about.php (tanpa .php)
    location / {
        try_files \$uri \$uri/ /\$uri.php?\$args /index.php?\$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;  # set SCRIPT_FILENAME, dll.
        fastcgi_pass 127.0.0.1:9000;
    }

    # Hardening kecil: blok dotfiles
    location ~ /\.(?!well-known) {
        deny all;
    }
}
NGINX

ln -sf /etc/nginx/sites-available/${APP_HOST} /etc/nginx/sites-enabled/${APP_HOST}
rm -f /etc/nginx/sites-enabled/default 2>/dev/null || true

# Bersihkan pid usang, test & (re)start nginx
rm -f /run/nginx.pid /var/run/nginx.pid 2>/dev/null || true
nginx -t
(nginx -s reload 2>/dev/null || nginx)

echo "Selesai: app siap di http://${APP_HOST}/ dan /about"
echo "Pastikan DNS: ${APP_HOST} -> IP Vingilot"


# di erendil
dig +short app.k07.com         # -> <IP Vingilot, mis. 10.67.3.6>
curl -sI http://app.k07.com/ | head -n1
curl -s  http://app.k07.com/ | sed -n '1,3p'

curl -sI http://app.k07.com/about | head -n1
curl -s  http://app.k07.com/about | sed -n '1,2p'

# akses via IP harus ditolak (bukan 200)
curl -sI http://<IP-Vingilot>/ | head -n1
