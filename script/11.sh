# Sirion
apt-get update
apt-get install -y nginx

# vhost reverse proxy
cat >/etc/nginx/sites-available/rp.k07.com <<'EOF'
# Tolak akses via IP (bukan hostname)
server {
    listen 80 default_server;
    server_name _;
    return 444;
}

# Reverse proxy utk www.k07.com & sirion.k07.com
server {
    listen 80;
    server_name www.k07.com sirion.k07.com;

    # root (opsional)
    location = / {
        return 200 "Sirion reverse proxy OK\n";
        add_header Content-Type text/plain;
    }

    # /static -> Lindon (10.67.3.5), hapus prefix /static/
    location /static/ {
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_http_version 1.1;
        proxy_pass http://10.67.3.5/;
    }

    # /app -> Vingilot (10.67.3.6), hapus prefix /app/
    location /app/ {
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_http_version 1.1;
        proxy_pass http://10.67.3.6/;
    }
}
EOF

ln -sf /etc/nginx/sites-available/rp.k07.com /etc/nginx/sites-enabled/rp.k07.com
rm -f /etc/nginx/sites-enabled/default 2>/dev/null || true

# bersihkan pid kosong, test & (re)start
rm -f /run/nginx.pid /var/run/nginx.pid 2>/dev/null || true
nginx -t
nginx 2>/dev/null || true
nginx -s reload 2>/dev/null || true

# di earendil
dig +short www.k07.com      # -> 10.67.3.2
dig +short sirion.k07.com   # -> 10.67.3.2

# klien-1
curl -sI http://www.k07.com/static/ | head -n1        # HTTP/1.1 200 OK
curl -s  http://www.k07.com/static/annals/ | grep -E '1.txt|2.txt'

# klien-2
curl -sI http://sirion.k07.com/static/ | head -n1
curl -s  http://sirion.k07.com/static/annals/ | grep -E '1.txt|2.txt'

# klien-1
curl -sI http://www.k07.com/app/ | head -n1
curl -s  http://www.k07.com/app/ | sed -n '1,3p'

# klien-2
curl -sI http://sirion.k07.com/app/ | head -n1
curl -s  http://sirion.k07.com/app/about | sed -n '1,2p'

curl -sI http://10.67.3.2/ | head -n1   # bukan 200 (444/404)
