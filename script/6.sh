# di valmar
# ambil serial dari ns1
dig @10.67.3.3 zein.com SOA +noall +answer | awk '{print $7}'
# ambil serial dari ns2
dig @10.67.3.4 zein.com SOA +noall +answer | awk '{print $7}'

nano /etc/bind/named.conf.local
zone "zein.com" {
    type slave;
    masters { 10.67.3.3; };                 // Tirion (ns1)
    file "/var/cache/bind/zein.com.slave";
    allow-notify { 10.67.3.3; };
    allow-transfer { 127.0.0.1; 10.67.3.0/24; };  // IZINKAN AXFR (lab)
};

named-checkconf
kill -HUP $(cat /run/named/named.pid) 2>/dev/null || \
{ pkill named; /usr/sbin/named -4 -u bind -c /etc/bind/named.conf; }

dig @127.0.0.1 zein.com AXFR
# atau
dig @10.67.3.4 zein.com AXFR
