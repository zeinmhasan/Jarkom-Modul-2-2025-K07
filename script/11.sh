# Sirion
apt-get update
apt-get install -y nginx

# vhost reverse proxy
cat >/etc/nginx/sites-available/rp.zein.com <<'EOF'
# Tolak akses via IP (bukan hostname)
server {
    listen 80 default_server;
    server_name _;
    return 444;
}

# Reverse proxy utk www.zein.com & sirion.zein.com
server {
    listen 80;
    server_name www.zein.com sirion.zein.com;

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

ln -sf /etc/nginx/sites-available/rp.zein.com /etc/nginx/sites-enabled/rp.zein.com
rm -f /etc/nginx/sites-enabled/default 2>/dev/null || true

# bersihkan pid kosong, test & (re)start
rm -f /run/nginx.pid /var/run/nginx.pid 2>/dev/null || true
nginx -t
nginx 2>/dev/null || true
nginx -s reload 2>/dev/null || true

# di earendil
dig +short www.zein.com      # -> 10.67.3.2
dig +short sirion.zein.com   # -> 10.67.3.2

# klien-1
curl -sI http://www.zein.com/static/ | head -n1        # HTTP/1.1 200 OK
curl -s  http://www.zein.com/static/annals/ | grep -E '1.txt|2.txt'

# klien-2
curl -sI http://sirion.zein.com/static/ | head -n1
curl -s  http://sirion.zein.com/static/annals/ | grep -E '1.txt|2.txt'

# klien-1
curl -sI http://www.zein.com/app/ | head -n1
curl -s  http://www.zein.com/app/ | sed -n '1,3p'

# klien-2
curl -sI http://sirion.zein.com/app/ | head -n1
curl -s  http://sirion.zein.com/app/about | sed -n '1,2p'

curl -sI http://10.67.3.2/ | head -n1   # bukan 200 (444/404)
