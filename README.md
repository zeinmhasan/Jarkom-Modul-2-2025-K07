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

<img width="830" height="605" alt="image" src="https://github.com/user-attachments/assets/a8b8321c-f378-416c-8395-31ada646cb02" />

