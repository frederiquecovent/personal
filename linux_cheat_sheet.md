# Notities Linux I

## Labo 1: User Management

### Gebruikers- en Groepsbeheer

- **UID / GID vinden**: `id`
- **(Interactive) gebruiker aanmaken**: `sudo adduser [GEBRUIKER]`
- **Gebruiker aanmaken**: `sudo useradd -m -s /bin/bash -c "Volledige Naam" [GEBRUIKER]` (m = maak home directory, s = shell)
- **Wachtwoord instellen**: `sudo passwd [GEBRUIKER]`
- **UID, gebruikersnaam, homedirectory, etc.**: `sudo cat /etc/passwd`
- **Groepen en leden van die groepen**: `cat /etc/group`
- **Wachtwoorden van gebruikers (hash)**: `sudo cat /etc/shadow`
- **Groep aanmaken**: `sudo groupadd [GROEP]`
- **Gebruiker toevoegen aan groep**: `sudo usermod -aG [GROEP] [GEBRUIKER]`
- **Primaire groep veranderen**: `sudo usermod -g [GROEP] [GEBRUIKER]`
- **Gebruiker maken, primaire en secundaire groep toewijzen in 1 commando**: `sudo useradd -g [PRI-GROEP] -G [SEC-GROEP1],[SEC-GROEP2] -m [GEBRUIKER]`
- **Groep verwijderen**: `sudo groupdel [GROEP]`
- **Gebruiker verwijderen**: `sudo userdel -r [GEBRUIKER]` (r = remove homedirectory)
- **Gebruiker aan sudo-groep toevoegen**: `usermod -aG sudo [GEBRUIKER]`
- **Groep en gebruiker van directory veranderen**: `sudo chown [GEBRUIKER]:[GROEP] [DIRECTORY]`
- **Groepseigenaar van directory wordt automatisch groepseigenaar van alle bestanden en directories (setgid)**: `chmod g+s [DIRECTORY]`
- **Enkel eigenaren van bestand kunnen bestand verwijderen (Sticky bit)**: `chmod +t [DIRECTORY]`

### Inloggen

- **Inloggen als root-gebruiker**: `su -`
- **Inloggen als eigen gebruiker met superuser-privileges**: `sudo su -`

- ("-" = volwaardige login)

### Gebruiker Disabelen / Enabelen

- **Gebruiker disable**: `sudo usermod -L [GEBRUIKER]`
- **Gebruiker disable (2)**: `passwd -l [GEBRUIKER]`
- **Gebruiker disable (3)**: `usermod -s /sbin/nologin [GEBRUIKER]`
- **Gebruiker enable**: `sudo usermod -U [GEBRUIKER]`
- **Gebruiker enable (2)**: `passwd -u [GEBRUIKER]`
- **Gebruiker enable (3)**: `usermod -s /bin/sh [GEBRUIKER]` OF `usermod -s /bin/bash [GEBRUIKER]`
- **Kijken of gebruiker locked is**: `sudo passwd -S [GEBRUIKER]` (L = locked, P = unlocked)


## Labo 2: Scripting 101

### Streams, pipes, redirects

- **Uitvoer wegschrijven**: `cmd > file`
- **Uitvoer toevoegen aan einde**: `cmd >> file`
- **Foutboodschappen webschrijven**: `cmd 2> file`
- **Inhoud gebruiken als invoer voor commando**: `cmd < file`
- **Uitvoer gebruiken als invoer voor commando**: `cmd1 | cmd2`
- **stdout en stderr apart wegschrijven**: `find / -type d > directories.txt 2> errors.txt`
- **stderr "negeren"**: `find / -type d > directories.txt 2> /dev/null`
- **stdout en stderr samen wegschrijven**: `find / -type d > all.txt 2>&1` OF `find / -type d &> all.txt`
- **Invoer én uitvoer omleiden**: `sort < unsorted.txt > sorted.txt 2> errors.txt`
- **Here documents (bv. meerdere lines afdrukken)**: `<< _EOF_ " ... " _EOF_`
- **Here strings (geen extra proces)**: `figlet <<< "Hello World"`


### Filters

- **Wegschrijven naar bestand én stdout (tonen)**: `tee all.txt`
- **Bestand omgekeerd afdrukken (omgekeerde cat)**: `tac all.txt`
- **Willekeurige volgorde afdrukken**: `shuf all.txt`
- **Eerste / laatste x aantal regels**: `head all.txt` `tail all.txt` (bekijk man page voor interessante args)
- **Alles behalve eerste regel**: `tail -n +2` 
- **Kolommen uit csv selecteren**: `cut -d: -f1,3-4 /etc/passwd`
- **Bestanden regel per regel samenvoegen**: `paste -d';' users.txt passwords.txt`
- **Sorteer input**: `sort file.txt` (n = numeric, r = reverse)
- **Toon enkel unieke items**: `uniq -c file.txt` (c = count)
- **Invoer in kolommen afdrukken**: `column -t -N user,passwd,uid,gid,name,home,shell -s: < /etc/passwd` (t = als tabel, J = in JSON)

#### SED

- **Zoeken en vervangen (1x per regel)**: `sed 's/foo/bar/'`
- **"Globaal", meerdere keren per regel**: `sed 's/foo/bar/g'`
- **Regels die beginnen met '#' verwijderen**: `sed '/^#/d'`
- **Lege regels verwijderen**: `sed '/^$/d'`

#### AWK-taal

- **Druk 4e kolom af (afgebakend door "whitespace")**: `awk '{ print $4 }'`
- **Enkel regels afdrukken die beginnen met #**: `awk '/^#/ { print $0 }'`
- **Druk kolom 2 en 4 af, gescheiden door ;**: `awk '{ printf "%s;%s", $2, $4 }'`
- **Druk de namen van de "gewone" gebruikers af**: `awk -F: '{ if($3 > 1000) print $1 }' /etc/passwd`

### Script schrijven

- **Eerste lijn = shebang**: `#! /usr/bin/env bash` OF andere interpreter (bv. `#! /usr/bin/python`)
- **Uitvoerbaar maken**: `chmod +x script.sh`
- **Variabele gebruiken**: `bestand=file.txt    touch "${bestand}"`
- **Script afbreken wanneer variabele niet bestaat**: `set -o nounset`
- **Script afbreken wanneer commando faalt**: `set -o errexit`
- **Enviroment varbiabele aanmaken**: `export VAR=value`


## Labo 3: Software-installatie, netwerk configuratie

### Software-installatie

#### Debian-based (Ubuntu, Debian, Mint)

- **Install a package**: `sudo apt install [PACKAGE]`
- **Update package list (repositories)**: `sudo apt update`
- **Upgrade installed packages**: `sudo apt upgrade`
- **Remove a package**: `sudo apt remove [PACKAGE]`
- **Search for a package**: `apt search [PACKAGE]`
- **Show package info**: `apt show [PACKAGE]`
- **Install a .deb file**: `sudo dpkg -i package_file.deb`
- **List files in a .deb file**: `dpkg -c package_file.deb`
- **Extract files from a .deb file**: `dpkg-deb -x package_file.deb [OUTPUT_DIR]`
- **Install dependencies**: `sudo apt install -f`
- **List installed packages**: `dpkg --list`


#### Red Hat-based (Fedora, RHEL, AlmaLinux)

- **Install a package**: `sudo dnf install [PACKAGE]`
- **Update package list (repositories)**: `sudo dnf check-update`
- **Upgrade installed packages**: `sudo dnf upgrade`
- **Remove a package**: `sudo dnf remove [PACKAGE]`
- **Search for a package**: `dnf search [PACKAGE]`
- **Show package info**: `dnf info [PACKAGE]`
- **Install a .rpm file**: `sudo rpm -i package_file.rpm`
- **Install dependencies**: `sudo dnf install package_file.rpm`
- **List installed packages**: `dnf list installed`

#### Other tools

##### Pip (Pyhton)

- **Install Python package**: `pip install [PACKAGE]`

##### NPM (Node.js)

- **Install Node.js package**: `npm install -g [PACKAGE]`

##### Snap (Cross-distribution)

- **Install snap package**: `sudo snap install [PACKAGE]`

##### Flatpack (Universal)

- **Install flatpack package**: `flatpack install [PACKAGE]`




### Netwerk configuratie

#### Viewing configuration

- **Show IP & Subnet mask**: `ip a`
- **Show default gateway**: `ip r`
- **Show DNS server (Debain-based)**: `resolvectl dns`
- **Show DNS server (Red Hat-based)**: `cat /etc/resolv.conf`

#### Find IP

- **Domain IP**: `host www.example.com` OR `dig www.example.com`
- **Public IP**: `curl icanhazip.com`

#### Configuratie (Debian-based)

- **Configure network interface**: `sudo nano /etc/netplan/1-network-manager-all.yaml`
```
network:
  version: 2
  renderer: NetworkManager
  ethernets:
    enp0s8:
      dhcp4: yes
      nameservers:
        addresses:
          - 192.168.76.12
```
- **Restart network**: `sudo ifdown [INTERFACE]` & `sudo ifup [INTERFACE]`


#### Configuratie (Red Hat-based)

- **Configure network interface**: `nano /etc/sysconfig/network-scripts/ifcfg-[INTERFACE]`
- **Restart network**: `sudo systemctl restart network`
- **Apply network changes**: `sudo nmcli device reapply [INTERFACE]` OR `sudo nmcli connection reload`
- **Bring interface up**: `nmcli connection show` & `sudo nmcli connection up 'System eth1'`

##### NetworkManager (EL >= 7, Fedora, Mint, ...)

- **UI based configuration**: `nmtui`

- **Show settings**: `nmcli -f IP4 device show [INTERFACE]`
```
sudo nmcli connection modify eth1 \
  ipv4.method manual \
  ipv4.addresses 192.168.56.9/24 ipv4.gateway 192.168.56.254 \
  ipv4.dns 192.168.56.254 ipv4.dns-search example.com
```
OR
```
sudo nmcli connection modify eth1 ipv4.method auto
```
- **Apply settings**: `sudo nmcli connection up [INTERFACE]`

#### DHCP Server Setup

- **Install ISC DHCP**: `sudo dnf install dhcp-server.x86_64`
- **Configure DHCP**: `nano /etc/dhcp/dhcpd.conf`
- **Example config file**:
```
default-lease-time 10800;
max-lease-time 86400;

subnet 192.168.76.0 netmask 255.255.255.0 {
        range 192.168.76.101 192.168.76.253;
        option routers 192.168.76.12;
        option domain-name "linux.lan";
        option domain-name-servers srv.linux.lan;
}

host LinuxMint22 {
        hardware ethernet 08:00:27:2f:c1:3b;
        fixed-address 192.168.76.150;
        default-lease-time 86400;
}
```
- **Test config file**: `dhcpd -t -cf /etc/dhcp/dhcpd.conf`

- **Enable NAT routing**: 
```bash
sudo firewall-cmd --permanent --direct --add-rule ipv4 nat POSTROUTING 0 -o [NAT INTERFACE] -j MASQUERADE
sudo firewall-cmd --add-masquerade --permanent
sudo firewall-cmd --reload
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p
```

#### Network monitoring & troubleshooting

- **Capturing with `tcpdump`**: `sudo tcpdump -w dhcp.pcap -i eth1 port 67 or port 68`
- **Read file**: `sudo tcpdump -r dhcp.pcap -ne#`
- **DHCP logs**: `sudo journalctl -f -u dhcpd.service`

## Labo 4: Webserver, scripting 102

### Webserver

LAMP-stack: **L**inux + **A**pache + **M**ariaDB + **P**HP

- **Installatie software**: `sudo dnf install httpd mariadb-server php`

- **Toon sockets**: `ss -tlnp` 
(l=listening, t=tcp, u=udp, n=numeric port nrs, p=processes)

- **Log bestanden bekijken**: `journalctl -f httpd` (f=follow (real time), S=since)

- **Database beveiligen**: `sudo mysql_secure_installation`

- **Inloggen op DB**: `mysql -u[USER] -p[PASSWORD] [DATABASE]`

#### Belangrijke directories

- **Config Apache**: `/etc/httpd/httpd.conf`
- **DocumentRoot Apache**: `/var/www/html`
- **Log bestanden**: `/var/log/httpd/[access/error]_log`


### Scripting 102

#### Positionele Parameters
- **Naam van het script**: `${0}`
- **Eerste, tweede, enz. argumenten**: `${1}, ${2}, ...`
- **Alle argumenten als één string**: `${*}`
- **Alle argumenten afzonderlijk**: `${@}`
- **Aantal argumenten**: `${#}`

- **Verschuift positie-parameters**: `shift`

#### Loops

- **While-lus**: `while [conditie]; do ...; done`
- **While-lus met teller**:
```bash
counter=0

while [ "${counter}" -le '10' ]; do
  echo "${counter}"
  counter=$((counter + 1))
done
```

- **Until-lus**:`until [conditie]; do ...; done`

- **For-lus**: `for VAR in LIST; do ...; done`
- **For-lus met teller**:
```bash
for i in {1..10}; do
  echo "${i}"
done
```
OF
```bash
for i in {2..20..2}; do
  echo "${i}"
done
```
OF
```bash
for i in $(seq 1 10); do
  echo "${i}"
done
```


- **Itereren over lijnen in een bestand**: 
```bash
while read -r line; do
    # process "${line}"
done < file.txt

```

- **Itereren over postitionele parameters**: 
```bash
while [ "$#" -gt 0 ]; do
  printf 'Arg: %s\n' "${1}"
  # ...
  shift
done
```
OF
```bash
for arg in "${@}"; do
  printf 'Arg: %s\n' "${arg}"
  # ...
done
```

#### Conditionals

- **If-else statement**:
```bash
if [conditie]
then 
    ...;
elif [conditie];
then 
    ...; 
else 
    ...; 
fi
```

OF

```bash
if [ "${#}" -gt '2' ]; then
  printf 'Expected at most 2 arguments, got %d\n' "${#}" >&2
  exit 1
fi
```

- **Operatoren**: 
 - `-gt` = greater then
 - `-lt` = less then


#### Returnstatus

- **Exitstatus van laatste commando**: `echo $?` (0=geslaagd, 1-255=gefaald)


## Labo 5: Hardening van een webserver

### Firewall Commands:

- **Check firewall status**: `sudo systemctl status firewalld`
- **List firewall rules**: `sudo firewall-cmd --list-all`

- **Allow service**: `sudo firewall-cmd --add-service=http --permanent`
- **Allow port**: `sudo firewall-cmd --add-port=8080/tcp`


- **Reload firewall**: `sudo firewall-cmd --reload`

- **List zones**: `firewall-cmd --get-zones`
- **List active zones**: `firewall-cmd --get-active-zones`
- **Add interface to active zone**: `firewall-cmd --add-interface=IFACE`

- **Panic mode on**: `firewall-cmd --panic-on`
- **Panic mode off**: `firewall-cmd --panic-off`

### SELinux Commands:

- **Check SELinux status**: `getenforce`
- **View SELinux config**: `cat /etc/selinux/config`

- **List booleans**: `getsebool -a`
- **Set boolean**: `sudo setsebool -P httpd_can_network_connect_db on`

- **View context of file**: `ls -lZ`
- **Restore file context**: `sudo restorecon -R /var/www/`
- **Set file context**: `sudo chcon -t httpd_sys_content_t test.php`

- **View denied actions**: `sudo grep denied /var/log/audit/audit.log`

## Labo 6: Scripting 103, automatiseren webserverinstallatie

### Scripting 103

#### Fouten opsporen

- **Syntax check**: `bash -n script.sh`
- **ShellCheck**: `shellcheck script.sh`
- **Debug mode**: `bash -x script.sh` (in het script: set -x EN set +x)

- **Fouten voorkomen**: 
```bash
set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes
``` 

- **Booleans in bash: exit-status v/e proces**: 
```bash
if COMMANDO; then
  # A
else
  # B
fi
```

A-blok wordt uitgevoerd als exit-status van COMMANDO 0 is (geslaagd, TRUE)

B-blok wordt uitgevoerd als exit-status van COMMANDO verschillend is van 0 (gefaald, FALSE)

- **vb. Maak user ${user} aan als die nog niet bestaat**: 
```bash
if ! getent passwd "${user}" > /dev/null 2>&1; then
  echo "Adding user ${user}"
  useradd "${user}"
else
  echo "User ${user} already exists"
fi
```

- **Operatoren && en ||**:<br/>
`command1 && command2`: command2 wordt enkel uitgevoerd als command1 succesvol was (exit 0)<br/>
`command1 || command2`: command2 wordt enkel uitgevoerd als command1 niet succesvol was (exit ≠ 0)

- **Test commando (geef exit status) (alias: " [ ")**: 
```bash
if [ "${#}" -eq "0" ]; then
  echo "Expected at least one argument"
fi
```

### Automatiseren webserverinstallatie

#### Vagrant commando's

- **Overzicht omgeving**: `vagrant status`
- **Start VM op**: `vagrant up VM`
- **Inloggen op VM**: `vagrant ssh VM`
- **VM uitschakelen**: `vagrant halt VM`
- **VM rebooten**: `vagrant reload VM`
- **Installatie-script uitvoeren**: `vagrant provision VM`
- **VM vernietigen**: `vagrant destroy VM`


## Labo 7: Scripting 201 & Cronjobs
### Bash Functions

- **Define a function**:
```bash
function_name() {
    # function code
}
```

- **Call a function**: `function_name arg1 arg2`

- **Return a status**: Use `return STATUS` (not `exit`).

- **Capture output (command substitution)**:
```bash
output=$(command arg1 arg2)
```
Stores `stdout` of `command` into `output`.

### Variable Scope in Functions
- **Global Scope Example**:
```bash
var_a=a
foo() {
    var_b=b
    echo "${var_a} ${var_b}"
}
foo
echo "${var_a} ${var_b}" # var_b is still accessible
```

- **Local Scope Example**:
```bash
var_a=a
foo() {
    local var_b=b
    echo "${var_a} ${var_b}"
}
foo
echo "${var_a} ${var_b}" # var_b is NOT accessible
```

### Parameter Substitution
#### Examples:
```bash
var="Hello world!"
echo "${other_var:-default}" # default
echo "${var,,}"    # hello world! (lowercase)
echo "${var^^}"    # HELLO WORLD! (uppercase)
echo "${var:2:5}"  # llo w (substring)
echo "${var//o/a}" # Hella warld! (replace)

------------------------------------------------

path="some/path/archive.tar.gz"
echo "${path#*/}"   # path/archive.tar.gz
echo "${path##*/}"  # archive.tar.gz
echo "${path%.*}"   # some/path/archive.tar
echo "${path%%.*}"  # some/path/archive

------------------------------------------------

option="${1}"
case "${option}" in
  -h|--help|'-?')
    usage
    exit 0
    ;;
  -v|--verbose)
    verbose=y
    shift
    ;;
  -*)
    printf 'Unrecognized option: %s\n' "${option}"
    usage
    exit 1
    ;;
esac
```


### Background Processes

#### Commands:
- **Suspend a process**: `Ctrl+Z`
- **Resume a suspended process in the background**: `bg`
- **List background processes**: `jobs` (-l voor PID)
- **Bring process NUM to foreground**: `fg NUM`
- **Start a process in the background**: `command &`

### One-Time Scheduling with at

- **Schedule a task**:
```bash
at now + 2 minutes
at> date > /tmp/date.txt
at> <Ctrl+D>
```
- **Other scheduling formats**:
- `at 3:03 AM`
- `at midnight`
- `at now + 3 weeks`

- **Commands**:
- List scheduled tasks: `atq`
- Remove task NUM: `atrm NUM`
- Voer taak uit wanneer systeem minder belast is: `batch`

### Recurring Scheduling with cron

- **Syntax of Crontab Entries**:

`MIN HOUR DOM MON DOW CMD`

- MIN: Minutes (0-59)
- HOUR: Hours (0-23)
- DOM: Day of the Month (1-31)
- MON: Month (1-12)
- DOW: Day of the Week (0-7, where 0 and 7 = Sunday)

- **Examples**:
```bash
    5 0 * * *       /path/to/command    # Daily at 00:05
    15 14 1 * *     /path/to/command    # Monthly on the 1st at 14:15
    0 22 * * 1-5    echo "It's 10pm"    # Weekdays at 22:00
```
    
- **Commands**:
  - **List user-specific cron jobs**: `crontab -l`
  - **Edit user-specific cron jobs**: `crontab -e`


## Labo 8: Troubleshooting & SSH

### Troubleshooting

#### TCP/IP troubleshooting

##### 1. Network access layer (Fysiek)
Verbinding tussen VM's controleren en of 'Cable Connected' aan staat in VirtualBox. (`ip link`)

##### 2. Internet layer (IP)
`ip a` of `ip -br a`
`ip r(oute)`

IP configuratie: 
1. `cat /etc/sysconfig/network-scripts/ifcfg-[INTERFACE]`
2. `sudo nmcli device reapply [INTERFACE]`
3. `sudo systemctl restart NetworkManager` 

DNS controleren: 
1. `cat /etc/resolv.conf` of `resolvectl dns` 

##### 3. Transport layer (Poorten)
1. Service running? `sudo systemctl status [SERVICE]`
2. Correct port/inteface? `sudo ss -tulpn`
3. Firewall settings: `sudo firewall-cmd --list-all`

##### 4. Application layer
1. Logs bekijken: `journalctl -f -u httpd.service` of `tail -f /var/log/httpd/error_log`
2. Test config syntax (bv. `apachectl configtest`)
3. CLI tools proberen (bv. smbclient, curl, dig, netcat, etc.)
4. Man pages bekijken

#### SELinux troubleshooting

##### File context
- **Is the file context as expected?** `ls -Z /var/www/html`
- **Set file context to default value**: `sudo restorecon -R /var/www/`
- **Set file context to specified value**: `sudo chcon -t httpd_sys_content_t test.php`

##### Booleans
- **Get boolean value**: `getsebool -a | grep http`
- **Enable boolean**: `sudo setsebool -P httpd_can_network_connect_db on`

### SSH

#### SSH Basic Commands
- **SSH into a remote server**: `ssh username@hostname_or_ip`
- **SSH with a custom port**: `ssh -p port_number username@hostname_or_ip`
- **SSH with private key**: `ssh -i /path/to/private_key username@hostname_or_ip`
- **Generate an SSH keypar**: `ssh-keygen -t rsa-sha2-512`
- **Copy SSH key to server**: `ssh-copy-id -i [PATH_TO_KEY] user@remote_server`

#### SSH Server Configuratie
- **/etc/ssh/sshd_config (server daemon)**:
```bash
#Port 22
#ListenAddress 0.0.0.0
PermitRootLogin prohibit-password
UsePAM yes
```
- **/etc/ssh/ssh_config (client daemon)**:
```bash
HostKeyAlgorithms=-ssh-rsa
StrictHostKeyChecking accept-new
```


## Labo 9: Mount

- **List block devices**: `lsblk`
- **List Sata disk devices**: `ls /dev/sd*`

### Partition Management

- **Display partitions of all disks**:  
  `sudo fdisk -l`  

- **Modify partitions of a specific disk**:  
  `sudo fdisk /dev/sdc`  
  - Interactive options include creating, deleting, or resizing partitions.

### Formatting a Partition

- **Format a partition with a specific filesystem**:  
  `sudo mkfs -t [FILESYSTEM] /dev/sdXY`  
  Examples:  
  - `sudo mkfs -t ext4 /dev/sdb1`  
  - `sudo mkfs -t vfat /dev/sdb2`  

- **Create a swap partition**:  
  `sudo mkswap /dev/sdXY`  
  Example: `sudo mkswap /dev/sdb3`  

### Reserved Blocks

- **Check reserved blocks for root**:  
  `sudo tune2fs -l /dev/sdXY | grep -i "block count"`  

- **Reduce reserved blocks to 3%**:  
  `sudo tune2fs -m 3 /dev/sdb3 "`  

### Mount Commands

- **Create a mount point**:  
  `sudo mkdir /mnt/newmountpoint`  

- **Mount a partition to a mount point**:  
  `sudo mount -t [FILESYSTEM] /dev/sdXY /mnt/newmountpoint`  
  Example: `sudo mount -t ext4 /dev/sdb3 /mnt/newmountpoint`  

- **Display all active mount points**:   
  `mount | grep sd`  

- **Check `/etc/fstab` for permanent mounts**:  
  `cat /etc/fstab`
  Example: `/dev/sdc1 /mnt/part1 ext4 defaults,ro 0 0`

- **Remount with specific options**:  
  `sudo mount -o remount,[OPTIONS] /mnt/newmountpoint`  
  Example: `sudo mount -o remount,ro /mnt/newmountpoint`  

- **Mount options**:  
  - `ro`: Read-only  
  - `rw`: Read-write  
  - `remount`: Apply new options to an already mounted device  

- **Unmount a partition**:  
  `sudo umount /mnt/newmountpoint`  
  OR  
  `sudo umount /dev/sdXY`  


### UUID Management

- **Lookup UUID of a device**:  
  `sudo blkid /dev/sdXY`  
  Example: `sudo blkid /dev/sda2`  

- **Retrieve UUID via filesystem details**:  
`sudo tune2fs -l /dev/sda2 | grep UUID`

## Labo 10: DNS met BIND

- **Install BIND**: `sudo dnf -y install bind`

- **BIND Configuration File (/etc/named.conf)**:
```bash
//
// named.conf
//
// Provided by Red Hat bind package to configure the ISC BIND named(8) DNS
// server as a caching only nameserver (as a localhost DNS resolver only).
//
// See /usr/share/doc/bind*/sample/ for example named configuration files.
//

options {
        listen-on port 53 { any; };
        listen-on-v6 port 53 { any; };
        directory       "/var/named";
        dump-file       "/var/named/data/cache_dump.db";   
        statistics-file "/var/named/data/named_stats.txt"; 
        memstatistics-file "/var/named/data/named_mem_stats.txt";
        secroots-file   "/var/named/data/named.secroots";  
        recursing-file  "/var/named/data/named.recursing"; 
        allow-query     { any; };

        /*
         - If you are building an AUTHORITATIVE DNS server, do NOT enable recursion.
         - If you are building a RECURSIVE (caching) DNS server, you need to enable
           recursion.
         - If your recursive DNS server has a public IP address, you MUST enable access
           control to limit queries to your legitimate users. Failing to do so will
           cause your server to become part of large scale DNS amplification
           attacks. Implementing BCP38 within your network would greatly
           reduce such attack surface
        */
        recursion yes;

        dnssec-validation no;

        managed-keys-directory "/var/named/dynamic";       
        geoip-directory "/usr/share/GeoIP";

        pid-file "/run/named/named.pid";
        session-keyfile "/run/named/session.key";

        /* https://fedoraproject.org/wiki/Changes/CryptoPolicy */
        include "/etc/crypto-policies/back-ends/bind.config";
};

logging {
        channel default_debug {
                file "data/named.run";
                severity dynamic;
        };
};

zone "." IN {
        type hint;
        file "named.ca";
};

zone "linux.lan" IN {
  type primary;
  file "linux.lan";
  notify yes;
  allow-update { none; };
};

zone "76.168.192.in-addr.arpa" IN {
  type primary;
  file "76.168.192.in-addr.arpa";
  notify yes;
  allow-update { none; };
};

include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";
```

- **BIND Forward Zone File (/var/named/linux.lan)**: 
```bash
$ORIGIN linux.lan.
$TTL 1W

@ IN SOA srv.linux.lan. hostmaster.linux.lan. (
  21120117 1D 1H 1W 1D )

       IN  NS     srv

       IN  MX     10 mail

db     IN  A      192.168.76.3

web    IN  A      192.168.76.4
www    IN  CNAME  web

srv    IN  A      192.168.76.254

mail   IN  A      192.168.76.10
smtp   IN  CNAME  mail
imap   IN  CNAME  mail
```

- **BIND Reverse Zone File (/var/named/76.168.192.in-addr.arpa)**:
```bash
$TTL 1W
$ORIGIN 76.168.192.in-addr.arpa.

@ IN SOA srv.linux.lan. hostmaster.linux.lan. (
  21120117 1D 1H 1W 1D )

       IN  NS     srv.linux.lan.

254    IN  PTR    srv.linux.lan.
4      IN  PTR    web.linux.lan.
3      IN  PTR    db.linux.lan.
10     IN  PTR    mail.linux.lan.

```

- **Start and Enable BIND**:
```bash
sudo systemctl enable named
sudo systemctl start named
```

- **Check BIND Config**:
```bash
sudo named-checkconf
sudo named-checkzone linux.lan /var/named/linux.lan
sudo named-checkzone 76.168.192.in-addr.arpa /var/named/76.168.192.in-addr.arpa
```

- **Firewall Config**:
```bash
sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo firewall-cmd --add-service=dns --permanent
sudo firewall-cmd --reload
```
