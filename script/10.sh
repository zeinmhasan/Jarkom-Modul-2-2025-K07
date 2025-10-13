# (di Vingilot)
apt-get update
apt-get install -y nginx php-fpm

# ubah pool FPM agar listen di 127.0.0.1:9000 (bukan socket)
FPM_CONF=$(ls /etc/php/*/fpm/pool.d/www.conf | head -n1)
sed -i 's|^listen = .*|listen = 127.0.0.1:9000|' "$FPM_CONF"
systemctl restart php*-fpm 2>/dev/null || service php*-fpm restart 2>/dev/null || true

mkdir -p /var/www/app
cat >/var/www/app/index.php <<'PHP'
<?php
header('Content-Type: text/plain');
echo "Welcome to app.zein.com (home)\n";
echo "Try /about\n";
?>
PHP

cat >/var/www/app/about.php <<'PHP'
<?php
header('Content-Type: text/plain');
echo "About: This is Vingilot (dynamic PHP)\n";
?>
PHP

cat >/etc/nginx/sites-available/app.zein.com <<'NGINX'
# Tolak akses via IP (default server)
server {
    listen 80 default_server;
    server_name _;
    return 444;
}

# Vhost dinamis untuk app.zein.com
server {
    listen 80;
    server_name app.zein.com;

    root /var/www/app;
    index index.php;

    # Pretty URL: coba file/dir, lalu coba "<path>.php", terakhir index.php
    location / {
        try_files $uri $uri/ /$uri.php?$args /index.php?$args;
    }

    # Jalur .php ditangani oleh PHP-FPM (TCP 127.0.0.1:9000)
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass 127.0.0.1:9000;
    }

    # Keamanan kecil: jangan izinkan akses ke file tersembunyi/konfigurasi
    location ~ /\.(?!well-known) {
        deny all;
    }
}
NGINX

ln -sf /etc/nginx/sites-available/app.zein.com /etc/nginx/sites-enabled/app.zein.com
rm -f /etc/nginx/sites-enabled/default 2>/dev/null || true

# bersihkan pid kosong, test & reload/start
rm -f /run/nginx.pid /var/run/nginx.pid 2>/dev/null || true
nginx -t
nginx 2>/dev/null || true
nginx -s reload 2>/dev/null || true

# di earendil
curl -sI http://app.zein.com/ | head -n1
curl -s  http://app.zein.com/ | sed -n '1,3p'

curl -sI http://app.zein.com/about | head -n1
curl -s  http://app.zein.com/about | sed -n '1,2p'
