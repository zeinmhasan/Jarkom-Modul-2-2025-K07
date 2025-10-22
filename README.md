# Jarkom-Modul-2-2025-K07

## ANGGOTA 
<table>
  <thead>
    <tr>
      <th>No</th>
      <th>Nama</th>
      <th>NRP</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>1</td>
      <td>Zein Muhammad Hasan</td>
      <td>5027241035</td>
    </tr>
    <tr>
      <td>2</td>
      <td>Ananda Fitri Wibowo</td>
      <td>5027241057</td>
    </tr>
  </tbody>
</table>

# Topologi Jaringan

| Nama Kota    | Interface | IP Address  | Gateway   |
|--------------|-----------|-------------|-----------|
| Eonwe    | eth1      | 10.67.1.1   | -         |
|              | eth2      | 10.67.2.1   | -         |
|              | eth3      | 10.67.3.1   | -         |
| Aerendil    | eth0      | 10.67.1.2   | 10.67.1.1 |
| Elwing | eth0      | 10.67.1.3   | 10.67.1.1 |
| Cirdan     | eth0      | 10.67.2.2   | 10.67.2.1 |
| Elrond   | eth0      | 10.67.2.3   | 10.67.2.1 |
| Maglor   | eth0      | 10.67.2.4   | 10.67.2.1 |
| Sirion   | eth0      | 10.67.3.2   | 10.67.3.1 |
| Tirion   | eth0      | 10.67.3.3   | 10.67.3.1 |
| Valmar   | eth0      | 10.67.3.4   | 10.67.3.1 |
| Lindon   | eth0      | 10.67.3.5   | 10.67.3.1 |
| Vingilot   | eth0      | 10.67.3.6   | 10.67.3.1 |


## SOAL 1
Di tepi Beleriand yang porak-poranda, Eonwe merentangkan tiga jalur: Barat untuk Earendil dan Elwing, Timur untuk Círdan, Elrond, Maglor, serta pelabuhan DMZ bagi Sirion, Tirion, Valmar, Lindon, Vingilot. Tetapkan alamat dan default gateway tiap tokoh sesuai glosarium yang sudah diberikan.

#### Eonwe Config
```
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
	address 10.67.1.1
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 10.67.2.1
	netmask 255.255.255.0

auto eth3
iface eth3 inet static
	address 10.67.3.1
	netmask 255.255.255.0
```

#### Aerendil Config
```
auto eth0
iface eth0 inet static
    address 10.67.1.2
    netmask 255.255.255.0
    gateway 10.67.1.1
dns-nameservers 192.168.122.1
```

#### Elwing Config
```
auto eth0
iface eth0 inet static
    address 10.67.1.3
    netmask 255.255.255.0
    gateway 10.67.1.1
```

#### Cirdan Config
```
auto eth0
iface eth0 inet static
    address 10.67.2.2
    netmask 255.255.255.0
    gateway 10.67.2.1
```

#### Elrond Config
```
auto eth0
iface eth0 inet static
    address 10.67.2.3
    netmask 255.255.255.0
    gateway 10.67.2.1
```

#### Maglor Config
```
auto eth0
iface eth0 inet static
    address 10.67.2.4
    netmask 255.255.255.0
    gateway 10.67.2.1
```

#### Sirion Config
```
auto eth0
iface eth0 inet static
    address 10.67.3.2
    netmask 255.255.255.0
    gateway 10.67.3.1
```

#### Tirion Config
```
auto eth0
iface eth0 inet static
    address 10.67.3.3
    netmask 255.255.255.0
    gateway 10.67.3.1
```

#### Valmar Config
```
auto eth0
iface eth0 inet static
    address 10.67.3.4
    netmask 255.255.255.0
    gateway 10.67.3.1
```

#### Lindon Config
```
auto eth0
iface eth0 inet static
    address 10.67.3.5
    netmask 255.255.255.0
    gateway 10.67.3.1
```

#### Vingilot Config
```
auto eth0
iface eth0 inet static
    address 10.67.3.6
    netmask 255.255.255.0
    gateway 10.67.3.1
```

<img width="390" height="295" alt="image" src="https://github.com/user-attachments/assets/6fb72019-4fc1-40ee-b2d0-dfd699e5516a" />

## Soal 2
Angin dari luar mulai berhembus ketika Eonwe membuka jalan ke awan NAT. Pastikan jalur WAN di router aktif dan NAT meneruskan trafik keluar bagi seluruh alamat internal sehingga host di dalam dapat mencapai layanan di luar menggunakan IP address.


Dengan menyambungkan Eonwe ke NAT, maka Eonwe sudah dapat mengakses internet.
<img width="425" height="133" alt="image" src="https://github.com/user-attachments/assets/2b0f8c50-21a1-4054-9f7c-55537520f41d" />

## Soal 3
Kabar dari Barat menyapa Timur. Pastikan kelima klien dapat saling berkomunikasi lintas jalur (routing internal via Eonwe berfungsi), lalu pastikan setiap host non-router menambahkan resolver 192.168.122.1 saat interfacenya aktif agar akses paket dari internet tersedia sejak awal.

Dengan konfigurasi yang sudah disampaikan pada #Soal1, maka sudah dipastikan setiap client terhubung satu sama lain.

## Soal 4
Para penjaga nama naik ke menara, di Tirion (ns1/master) bangun zona xxxx.com sebagai authoritative dengan SOA yang menunjuk ke ns1.xxxx.com dan catatan NS untuk ns1.xxxx.com dan ns2.xxxx.com. Buat A record untuk ns1.xxxx.com dan ns2.xxxx.com yang mengarah ke alamat Tirion dan Valmar sesuai glosarium, serta A record apex xxxx.com yang mengarah ke alamat Sirion (front door), aktifkan notify dan allow-transfer ke Valmar, set forwarders ke 192.168.122.1. Di Valmar (ns2/slave) tarik zona xxxx.com dari Tirion dan pastikan menjawab authoritative. pada seluruh host non-router ubah urutan resolver menjadi IP dari ns1.xxxx.com → ns2.xxxx.com → 192.168.122.1. Verifikasi query ke apex dan hostname layanan dalam zona dijawab melalui ns1/ns2.


### Bagian 1: Tirion - ns1/master
- Install paket BIND9 dan alat bantunya
```
apt-get update
apt-get install -y bind9 bind9-utils dnsutils || true
```
- Buat direktori yang diperlukan agar BIND bisa berjalan dan mengatur izin agar bisa menulis cache dan log.
```
mkdir -p /etc/bind/zones /var/cache/bind /run/named
id bind 2>/dev/null || useradd -r -s /usr/sbin/nologin bind || true
chown -R bind:bind /etc/bind /var/cache/bind /run/named
```
- Definisikan variabel agar skrip lebih mudah dibaca dan diubah.
```
DOMAIN="k07.com"
NS1="10.67.3.3"    # Tirion
NS2="10.67.3.4"    # Valmar
APEX="10.67.3.2"   # Sirion
SERIAL="$(date +%Y%m%d)01"
```
- Buat file konfigurasi OPSI GLOBAL untuk BIND.
```
cat >/etc/bind/named.conf.options <<EOF
options {
    directory "/var/cache/bind";
    recursion yes;
    allow-recursion { any; };
    dnssec-validation no;
    forwarders { 192.168.122.1; };
    listen-on { any; };
    listen-on-v6 { any; };
};
EOF
```
- Buat file konfigurasi LOKAL untuk BIND, di sinilah kita mendefinisikan ZONA kita.
```
cat >/etc/bind/named.conf.local <<EOF
zone "$DOMAIN" {
    type master;
    file "/etc/bind/zones/db-$DOMAIN";
    notify yes;
    also-notify { $NS2; };        // Valmar
    allow-transfer { $NS2; };     // izinkan AXFR ke ns2
};
EOF
```
- Buat file zona (database DNS).
```
cat >/etc/bind/zones/db-$DOMAIN <<EOF
\$TTL 300
@   IN SOA  ns1.$DOMAIN. admin.$DOMAIN. (
        $SERIAL   ; Serial
        3600      ; Refresh
        900       ; Retry
        1209600   ; Expire
        300 )     ; Minimum

; Authoritative nameservers
    IN NS   ns1.$DOMAIN.
    IN NS   ns2.$DOMAIN.

; Host records untuk NS
ns1 IN A $NS1
ns2 IN A $NS2

; Apex mengarah ke front door (Sirion)
@   IN A $APEX

; Contoh tambahan (opsional)
; www IN CNAME @
; api IN A $APEX
EOF
```
- Periksa file konfigurasi untuk kesalahan sintaks.
```
named-checkconf
```
- Periksa file zona untuk memeriksa kesalahan.
```
named-checkzone "$DOMAIN" /etc/bind/zones/db-$DOMAIN
```
- Jalankan server BIND di background.
```
 /usr/sbin/named -4 -u bind -c /etc/bind/named.conf
```

### Bagian 2: Valmar - ns2/slave
- Install paket BIND9 dan alat bantunya
```
apt-get update
apt-get install -y bind9 bind9-utils dnsutils || true
```
- Buat direktori yang diperlukan agar BIND bisa berjalan dan mengatur izin agar bisa menulis cache dan log.
```
mkdir -p /etc/bind/zones /var/cache/bind /run/named
id bind 2>/dev/null || useradd -r -s /usr/sbin/nologin bind || true
chown -R bind:bind /etc/bind /var/cache/bind /run/named
```
- Definisikan variabel agar skrip lebih mudah dibaca dan diubah.
```
DOMAIN="k07.com"    
NS1="10.67.3.3"
NS2="10.67.3.4"
```
- Buat file konfigurasi OPSI GLOBAL untuk BIND.
```
cat >/etc/bind/named.conf.options <<EOF
options {
    directory "/var/cache/bind";
    recursion yes;
    allow-recursion { any; };
    dnssec-validation no;
    forwarders { 192.168.122.1; };
    listen-on { any; };
    listen-on-v6 { any; };
};
EOF
```
- Buat file konfigurasi LOKAL untuk BIND, di sinilah kita mendefinisikan ZONA kita.
```
cat >/etc/bind/named.conf.local <<EOF
zone "$DOMAIN" {
    type slave;
    masters { $NS1; };                    // Tirion
    file "/var/cache/bind/$DOMAIN.slave";
    allow-notify { $NS1; };
};
EOF
```
- Cek konfigurasi dan jalankan service BIND.
```
named-checkconf
 /usr/sbin/named -4 -u bind -c /etc/bind/named.conf
```

### Bagian 3: Konfigurasi Klien - Semua Host Lain
- Hapus file resolv.conf lama dan buat file resolve.conf yang baru.
```
rm -f /etc/resolv.conf
cat >/etc/resolv.conf <<EOF
nameserver 10.67.3.3   # ns1 (Tirion)
nameserver 10.67.3.4   # ns2 (Valmar)
nameserver 192.168.122.1
# search $DOMAIN
EOF
```
- Cek apakah Tirion dan Valmar merespon dengan 'Authoritative Answer'.
```
dig @10.67.3.3 $DOMAIN A +norecurse +noall +answer +authority +comments
dig @10.67.3.4 $DOMAIN A +norecurse +noall +answer +authority +comments
```
- Cek apakah Tirion tahu siapa NS dan apa IP mereka.
```
dig @10.67.3.3 $DOMAIN NS +norecurse +noall +answer
dig @10.67.3.3 ns1.$DOMAIN A +noall +answer
dig @10.67.3.3 ns2.$DOMAIN A +noall +answer
```
- Tes permintaan 'Full Zone Transfer' (AXFR) dari Valmar.
```
dig @10.67.3.4 $DOMAIN AXFR
```
- Uji apakah file /etc/resolv.conf berfungsi dengan benar.
```
dig $DOMAIN A +noall +answer
dig ns1.$DOMAIN A +noall +answer
dig ns2.$DOMAIN A +noall +answer
```

## Soal 5
“Nama memberi arah,” kata Eonwe. Namai semua tokoh (hostname) sesuai glosarium, eonwe, earendil, elwing, cirdan, elrond, maglor, sirion, tirion, valmar, lindon, vingilot, dan verifikasi bahwa setiap host mengenali dan menggunakan hostname tersebut secara system-wide. Buat setiap domain untuk masing masing node sesuai dengan namanya (contoh: eru.xxxx.com) dan assign IP masing-masing juga. Lakukan pengecualian untuk node yang bertanggung jawab atas ns1 dan ns2

### Bagian 1: Tirion
- Definisikan variabel 'ZONE' agar mudah digunakan, berisi path ke file database (file zona) BIND.
```
ZONE=/etc/bind/zones/db-k07.com
SERIAL=$(date +%Y%m%d)01
```
- Buat perintah 'sed' (Stream Editor) untuk mengedit file secara otomatis, agar nomor serial dinaikkan di file zona. Ini adalah sinyal agar server slave (Valmar) tahu ada pembaruan.
```
sed -i "s/^[[:space:]]*[0-9]\{10\}[[:space:]]*; Serial.*/        $SERIAL   ; Serial/" "$ZONE"
```
- Tambahkan host records.
```
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
```
- Periksa sintaks file zona yang baru kita edit untuk error.
```
named-checkzone k07.com "$ZONE"
```
- Jika ok, reload layanan BIND9 agar membaca perubahan baru.
```
kill -HUP $(cat /run/named/named.pid) 2>/dev/null || rndc reload k07.com
```

### Bagian 2: Valmar
- Cek dengan perintah verifikasi apakah semua record baru (earendil, elwing, dll) sudah tiba di Valmar.
```
dig @10.67.3.4 k07.com AXFR | egrep 'IN[[:space:]]+(A|NS|SOA|CNAME)' | sed -E 's/[[:space:]]+/ /g' | sort
```

### Bagian 3: Aerendil
- Atur short hostname
```
echo earendil > /etc/hostname
hostname earendil
```
- Tambah hostname ke /etc/hosts.
```
grep -q '127.0.1.1 earendil.k07.com earendil' /etc/hosts || \
echo '127.0.1.1 earendil.k07.com earendil' >> /etc/hosts
```
- Pastikan resolv.conf punya search domain.
```
grep -q '^search k07.com' /etc/resolv.conf || \
{ sed -i '1i search k07.com' /etc/resolv.conf 2>/dev/null || true; }
```
- Verifikasi dan uji database nama sistem.
```
hostname -f     
getent hosts earendil
getent hosts earendil.k07.com
```

### Bagian 4: Tirion & Valmar
#### Tirion
- Tambahkan hostname ke /etc/hosts.
```
echo ns1 > /etc/hostname
hostname ns1
grep -q '127.0.1.1 ns1.k07.com ns1' /etc/hosts || \
echo '127.0.1.1 ns1.k07.com ns1' >> /etc/hosts
hostname -f
```

#### Valmar
- Tambahkan hostname ke /etc/hosts.
```
echo ns2 > /etc/hostname
hostname ns2
grep -q '127.0.1.1 ns2.k07.com ns2' /etc/hosts || \
echo '127.0.1.1 ns2.k07.com ns2' >> /etc/hosts
hostname -f
```

### Bagian 6: Aerendil
- Timpa file /etc/resolv.conf, sesuai dengan urutan relosver yang diminta oleh soal.
```
sudo bash -c 'cat > /etc/resolv.conf' <<'EOF'
search k07.com
nameserver 10.67.3.3   # ns1 (Tirion)
nameserver 10.67.3.4   # ns2 (Valmar)
nameserver 192.168.122.1
EOF
```
- Uji search domain, resolusi FQDN, dan cek manual.
```
getent hosts earendil
getent hosts cirdan
ping -c1 elrond

dig earendil.k07.com +short
dig ns1.k07.com +short

cat /etc/resolv.conf
```














## Soal 6
Lonceng Valmar berdentang mengikuti irama Tirion. Pastikan zone transfer berjalan, Pastikan Valmar (ns2) telah menerima salinan zona terbaru dari Tirion (ns1). Nilai serial SOA di keduanya harus sama

Di Valmar:
- Ambil serial dari ns1 dan ns2
```
dig @10.67.3.3 k07.com SOA +noall +answer | awk '{print $7}'
dig @10.67.3.4 k07.com SOA +noall +answer | awk '{print $7}'
```
- Konfigurasi slave, pastikan allow transfer.
```
nano /etc/bind/named.conf.local
zone "k07.com" {
    type slave;
    masters { 10.67.3.3; };                 // Tirion (ns1)
    file "/var/cache/bind/k07.com.slave";
    allow-notify { 10.67.3.3; };
    allow-transfer { 127.0.0.1; 10.67.3.0/24; };  // IZINKAN AXFR (lab)
};
```
- Cek sintaks konfigurasi BIND dan reload service BIND.
```
named-checkconf
kill -HUP $(cat /run/named/named.pid) 2>/dev/null || \
{ pkill named; /usr/sbin/named -4 -u bind -c /etc/bind/named.conf; }
```
- Verifikasi zone transfer (AXFR).
```
dig @127.0.0.1 k07.com AXFR
# atau
dig @10.67.3.4 k07.com AXFR
```

## Soal 7
Peta kota dan pelabuhan dilukis. Sirion sebagai gerbang, Lindon sebagai web statis, Vingilot sebagai web dinamis. Tambahkan pada zona xxxx.com A record untuk sirion.xxxx.com (IP Sirion), lindon.xxxx.com (IP Lindon), dan vingilot.xxxx.com (IP Vingilot). Tetapkan CNAME :
- www.xxxx.com → sirion.xxxx.com, 
- static.xxxx.com → lindon.xxxx.com, dan 
- app.xxxx.com → vingilot.xxxx.com.

Verifikasi dari dua klien berbeda bahwa seluruh hostname tersebut ter-resolve ke tujuan yang benar dan konsisten.

### Di Tirion:
- Tetapkan variabel.
```
DOMAIN="k07.com"
ZONE="/etc/bind/zones/db-$DOMAIN"

SIRION_IP="10.67.3.2"
LINDON_IP="10.67.3.5" 
VINGILOT_IP="10.67.3.6" 
```
- Naikkan serial SOA.
```
SERIAL="$(date +%Y%m%d)01"
sed -i "0,/; Serial/{s/^[[:space:]]*[0-9]\{10\}[[:space:]]*; Serial.*/        $SERIAL   ; Serial/}" "$ZONE"
```
- Tambahkan/refresh blok host dan CNAME.
```
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
```
- Validasi dan reload.
```
named-checkzone "$DOMAIN" "$ZONE"
kill -HUP "$(cat /run/named/named.pid)" 2>/dev/null || true
```

### Di Cirdan dan Aerendil
- Pastikan /etc/resolv.conf klien sudah benar.
```
cat >/etc/resolv.conf <<'EOF'
search k07.com
nameserver 10.67.3.3
nameserver 10.67.3.4
nameserver 192.168.122.1
EOF
```
- Verifikasi host.
```
for h in sirion lindon vingilot www static app; do
  echo "== $h.k07.com"
  dig +short "$h.k07.com"
done
```

## Soal 8
Setiap jejak harus bisa diikuti. Di Tirion (ns1) deklarasikan satu reverse zone untuk segmen DMZ tempat Sirion, Lindon, Vingilot berada. Di Valmar (ns2) tarik reverse zone tersebut sebagai slave, isi PTR untuk ketiga hostname itu agar pencarian balik IP address mengembalikan hostname yang benar, lalu pastikan query reverse untuk alamat Sirion, Lindon, Vingilot dijawab authoritative.

### Bagian 1: Tirion
- Tetapkan variabel untuk domain dan file zona.
```
DOMAIN="k07.com"
REVZONE="3.67.10.in-addr.arpa"
ZONEFILE="/etc/bind/zones/db-$REVZONE"
```
- Pastikan direktori sudah ada.
```
mkdir -p /etc/bind/zones
```
- Tambah deklarasi zona reverse (master) dengan notify & transfer ke ns2.
```
cat >> /etc/bind/named.conf.local <<EOF

zone "$REVZONE" {
    type master;
    file "$ZONEFILE";
    notify yes;
    also-notify { 10.67.3.4; };    // ns2 (Valmar)
    allow-transfer { 10.67.3.4; }; // izinkan AXFR ke ns2
};
EOF
```
- Buat file zona reverse dengan PTR untuk DMZ hosts
```
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
```
- Validasi & muat ulang BIND.
```
named-checkzone "$REVZONE" "$ZONEFILE"
kill -HUP "$(cat /run/named/named.pid)" 2>/dev/null || true
```

### Di Valmar
- Deklarasi zona slave.
```
REVZONE="3.67.10.in-addr.arpa"
cat >> /etc/bind/named.conf.local <<EOF

zone "$REVZONE" {
    type slave;
    masters { 10.67.3.3; };                 // ns1 (Tirion)
    file "/var/cache/bind/$REVZONE.slave";
    allow-notify { 10.67.3.3; };
    // (opsional lab) allow-transfer { 127.0.0.1; 10.67.3.0/24; };
};
EOF
```
- Cek sintaks konfigurasi dan reload BIND.
```
named-checkconf
# reload/ start named
kill -HUP "$(cat /run/named/named.pid)" 2>/dev/null || \
{ pkill named 2>/dev/null; /usr/sbin/named -4 -u bind -c /etc/bind/named.conf; }
```

### Di Cirdan dan Aerendil
- Verifikasi host.
```
for ip in 10.67.3.2 10.67.3.5 10.67.3.6; do
  echo "== -x $ip"
  dig -x "$ip" +short
done
```

## Soal 9
Lampion Lindon dinyalakan. Jalankan web statis pada hostname static.xxxx.com dan buka folder arsip /annals/ dengan autoindex (directory listing) sehingga isinya dapat ditelusuri. Akses harus dilakukan melalui hostname, bukan IP.

### Di Lindon
- Perbarui daftar paket, lalu install Nginx
```
apt-get update
apt-get install -y nginx
```
- Buat direktori web dan file index.html sebagai halaman utama.
```
mkdir -p /var/www/static/annals
echo "Hello from static.k07.com" > /var/www/static/index.html
```
- Buat file-file dummy di dalam /annals/ agar ada sesuatu yang bisa ditampilkan oleh autoindex.
```
echo "chronicle-1" > /var/www/static/annals/1.txt
echo "chronicle-2" > /var/www/static/annals/2.txt
```
- Buat file konfiigurasi server block baru.
```
cat >/etc/nginx/sites-available/static.k07.com <<'EOF'
server {
    listen 80;
    server_name static.k07.com;

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
```
- Buat file konfigurasi 'default' yang akan menangkap semua request yang tidak cocok dengan 'server_name'.
```
cat >/etc/nginx/sites-available/000-default-deny <<'EOF'
server {
    listen 80 default_server;
    server_name _;

    # drop cepat; bisa juga return 404 kalau kamu mau
    return 444;
}
EOF
```
- Aktifkan konfigurasi dengan membuat 'symbolic link' (shortcut) dari 'sites-available' ke 'sites-enabled'.
```
ln -sf /etc/nginx/sites-available/static.k07.com /etc/nginx/sites-enabled/static.k07.com
ln -sf /etc/nginx/sites-available/000-default-deny /etc/nginx/sites-enabled/000-default-deny
```
- Hapus file konfigurasi default Nginx agar tidak bentrok, kemudian reload.
```
rm -f /etc/nginx/sites-enabled/default 2>/dev/null || true
nginx -t && nginx -s reload || systemctl reload nginx 2>/dev/null || service nginx reload 2>/dev/null
```
- Bersihkan pidfile kosong & start fresh.
```
rm -f /run/nginx.pid /var/run/nginx.pid 2>/dev/null || true
nginx -t
nginx
```
- Kalau mau paksa reload setelahj perubahan
```
nginx -s reload 2>/dev/null || true
```
- Verifikasi proses & port
```
ps aux | grep '[n]ginx'
ss -lntp | grep ':80 '

sed -n '1,120p' /etc/nginx/sites-available/static.k07.com
```

### Di Aerendil atau Cirdan
- Pastikan bahwa 'static.k07.com' bisa di-resolve ke IP Lindon oleh server DNS (Tirion).
```
dig +short static.k07.com
```

## Soal 10
Vingilot mengisahkan cerita dinamis. Jalankan web dinamis (PHP-FPM) pada hostname app.xxxx.com dengan beranda dan halaman about, serta terapkan rewrite sehingga /about berfungsi tanpa akhiran .php. Akses harus dilakukan melalui hostname.


## Soal 11
Di muara sungai, Sirion berdiri sebagai reverse proxy. Terapkan path-based routing: /static → Lindon dan /app → Vingilot, sambil meneruskan header Host dan X-Real-IP ke backend. Pastikan Sirion menerima www.xxxx.com (kanonik) dan sirion.xxxx.com, dan bahwa konten pada /static dan /app di-serve melalui backend yang tepat.


