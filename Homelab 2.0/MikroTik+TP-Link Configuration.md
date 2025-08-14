# MikroTik Router Configuration

## Network Architecture Overview

This configuration implements a segmented network using VLANs with the following structure:
- **VLAN 10:** Main LAN (10.10.10.0/24)
- **VLAN 20:** Servers (10.10.20.0/24)
- **VLAN 30:** IoT Devices (10.10.30.0/24)
- **VLAN 40:** Guest Network (10.10.40.0/24)
- **VLAN 99:** Management (10.10.99.0/24)
- **WireGuard VPN:** Remote access (10.100.100.0/24)

**mDNS is used together with MACVLANs and a bridge to make casting work from VLAN10 -> VLAN30**

---

### System Reset (Optional but Recommended)

```bash
/system reset-configuration no-defaults=yes skip-backup=yes
```

**Note:** Wait for reboot, then apply this configuration

---

## Interface Configuration

### Bridge Interfaces
```bash
# Main bridge. Disable VLAN filtering for now
/interface bridge add name=bridge1 vlan-filtering=no

# Secondary bridge for mDNS repeating between LAN and IoT
/interface bridge add igmp-snooping=yes name=bridgemDNS
```

### WireGuard VPN Interface
```bash
# WireGuard VPN server listening on port 51820
/interface wireguard add listen-port=51820 mtu=1420 name=wireguard0 private-key="<PRIVATE_KEY>"
```

### VLAN Interfaces
```bash
# Main LAN network for primary devices
/interface vlan add interface=bridge1 name=vlan10-lan vlan-id=10

# Server network for dedicated servers
/interface vlan add interface=bridge1 name=vlan20-servers vlan-id=20

# IoT network for smart home devices
/interface vlan add interface=bridge1 name=vlan30-iot vlan-id=30

# Guest network for visitor access
/interface vlan add interface=bridge1 name=vlan40-guest vlan-id=40

# Management network for router administration
/interface vlan add interface=bridge1 name=vlan99-mgmt vlan-id=99
```

### MAC VLAN Interfaces
```bash
# MAC VLAN for LAN network bridging to mDNS bridge
/interface macvlan add interface=vlan10-lan mac-address=<MAC_ADDRESS> name=macvlan10

# MAC VLAN for IoT network bridging to mDNS bridge
/interface macvlan add interface=vlan30-iot mac-address=<MAC_ADDRESS> name=macvlan30
```

### Interface Lists
```bash
# WAN interface list for internet-facing connections
/interface list add name=WAN

# LAN interface list for internal networks
/interface list add name=LAN
```

---

## DHCP Configuration

### IP Address Pools
```bash
# DHCP pool for main LAN devices
/ip pool add name=pool-lan ranges=10.10.10.100-10.10.10.200

# DHCP pool for server network
/ip pool add name=pool-servers ranges=10.10.20.100-10.10.20.200

# DHCP pool for IoT devices
/ip pool add name=pool-iot ranges=10.10.30.100-10.10.30.200

# DHCP pool for guest devices
/ip pool add name=pool-guest ranges=10.10.40.100-10.10.40.200

# DHCP pool for management devices
/ip pool add name=pool-mgmt ranges=10.10.99.100-10.10.99.200
```

### DHCP Servers
```bash
# DHCP server for main LAN
/ip dhcp-server add address-pool=pool-lan interface=vlan10-lan name=dhcp-lan

# DHCP server for server network
/ip dhcp-server add address-pool=pool-servers interface=vlan20-servers name=dhcp-servers

# DHCP server for IoT network
/ip dhcp-server add address-pool=pool-iot interface=vlan30-iot name=dhcp-iot

# DHCP server for guest network
/ip dhcp-server add address-pool=pool-guest interface=vlan40-guest name=dhcp-guest

# DHCP server for management network
/ip dhcp-server add address-pool=pool-mgmt interface=vlan99-mgmt name=dhcp-mgmt
```

### DHCP Networks
```bash
# DHCP network configuration for LAN
/ip dhcp-server network add address=10.10.10.0/24 dns-server=10.10.10.1 gateway=10.10.10.1

# DHCP network configuration for servers
/ip dhcp-server network add address=10.10.20.0/24 dns-server=10.10.20.1 gateway=10.10.20.1

# DHCP network configuration for IoT devices
/ip dhcp-server network add address=10.10.30.0/24 dns-server=10.10.30.1 gateway=10.10.30.1

# DHCP network configuration for guest network
/ip dhcp-server network add address=10.10.40.0/24 dns-server=10.10.40.1 gateway=10.10.40.1

# DHCP network configuration for management network
/ip dhcp-server network add address=10.10.99.0/24 dns-server=10.10.99.1 gateway=10.10.99.1
```

### Static DHCP Lease
```bash
# Static IP assignment for management device (Raspberry Pi)
/ip dhcp-server lease add address=<STATIC_IP> client-id=<CLIENT_ID> mac-address=<MAC_ADDRESS> server=dhcp-mgmt
```

---

## Physical Port Configuration

### Bridge Port Assignment
```bash
# Trunk port for VLAN traffic (to switch)
/interface bridge port add bridge=bridge1 interface=ether2

# Management VLAN access port (untagged VLAN 99 -> direct management access)
/interface bridge port add bridge=bridge1 interface=ether5 pvid=99

# Bridge MAC VLANs for mDNS functionality
/interface bridge port add bridge=bridgemDNS interface=macvlan10
/interface bridge port add bridge=bridgemDNS interface=macvlan30
```

### VLAN Bridge Configuration
```bash
# Management VLAN configuration (tagged on ether2 (AP), untagged on ether5, for direct management)
/interface bridge vlan add bridge=bridge1 tagged=ether2 untagged=ether5 vlan-ids=99

# All other VLANs tagged on trunk port ether2 (to AP)
/interface bridge vlan add bridge=bridge1 tagged=ether2 vlan-ids=10,20,30,40
```

### Interface List Membership
```bash
# WAN interface assignment
/interface list member add interface=ether1 list=WAN

# LAN interface assignments for all VLANs
/interface list member add interface=vlan10-lan list=LAN
/interface list member add interface=vlan20-servers list=LAN
/interface list member add interface=vlan30-iot list=LAN
/interface list member add interface=vlan40-guest list=LAN
/interface list member add interface=vlan99-mgmt list=LAN
```

---

## IP Address Configuration

```bash
# Gateway IP for main LAN network
/ip address add address=10.10.10.1/24 interface=vlan10-lan network=10.10.10.0

# Gateway IP for server network
/ip address add address=10.10.20.1/24 interface=vlan20-servers network=10.10.20.0

# Gateway IP for IoT network
/ip address add address=10.10.30.1/24 interface=vlan30-iot network=10.10.30.0

# Gateway IP for guest network
/ip address add address=10.10.40.1/24 interface=vlan40-guest network=10.10.40.0

# Gateway IP for management network
/ip address add address=10.10.99.1/24 interface=vlan99-mgmt network=10.10.99.0

# WireGuard VPN server IP
/ip address add address=10.100.100.1/24 interface=wireguard0 network=10.100.100.0
```

---

## VPN Configuration

### WireGuard Peers
```bash
# Laptop VPN client configuration
/interface wireguard peers add allowed-address=10.100.100.2/32 interface=wireguard0 name=Laptop public-key="<PUBLIC_KEY>"

# iPhone VPN client configuration
/interface wireguard peers add allowed-address=10.100.100.3/32 interface=wireguard0 name=iPhone public-key="<PUBLIC_KEY>"
```

---

## DNS Configuration

```bash
# DHCP client on WAN interface (no ISP DNS usage)
/ip dhcp-client add interface=ether1 use-peer-dns=no

# DNS server configuration using AdGuard Home with mDNS repeating
/ip dns set allow-remote-requests=yes mdns-repeat-ifaces=vlan10-lan,vlan30-iot servers=<ADGUARD_IP>
```

---

## Firewall Rules

### Input Chain (Traffic to Router)
```bash
# Allow established/related connections
/ip firewall filter add action=accept chain=input comment="Allow established/related connections to router" connection-state=established,related

# Drop invalid connections
/ip firewall filter add action=drop chain=input comment="Drop invalid connections" connection-state=invalid

# Block WAN traffic not destined for router
/ip firewall filter add action=drop chain=input comment="Drop WAN traffic not for router" dst-address-type=!local in-interface=ether1

# Allow HTTPS access from management VLAN
/ip firewall filter add action=accept chain=input comment="Allow HTTPS from management VLAN" dst-port=443 in-interface=vlan99-mgmt protocol=tcp

# Allow Winbox access from management VLAN
/ip firewall filter add action=accept chain=input comment="Allow Winbox from management VLAN" dst-port=8291 in-interface=vlan99-mgmt protocol=tcp

# Allow DNS requests from all VLANs
/ip firewall filter add action=accept chain=input comment="Allow DNS from VLANs" dst-port=53 in-interface-list=LAN protocol=udp
/ip firewall filter add action=accept chain=input comment="Allow DNS TCP fallback" dst-port=53 in-interface-list=LAN protocol=tcp

# Allow DHCP requests from all VLANs
/ip firewall filter add action=accept chain=input comment="Allow DHCP from VLANs" dst-port=67 in-interface-list=LAN protocol=udp

# Allow ICMP from all VLANs
/ip firewall filter add action=accept chain=input comment="Allow ICMP from VLANs" in-interface-list=LAN protocol=icmp

# Allow WireGuard VPN connections from WAN
/ip firewall filter add action=accept chain=input comment="Allow WireGuard VPN" dst-port=51820 in-interface=ether1 protocol=udp

# Allow traffic from VPN clients
/ip firewall filter add action=accept chain=input comment="Allow input from WireGuard VPN clients" in-interface=wireguard0
```

### Security Logging Rules
```bash
# Log SSH brute force attempts from WAN
/ip firewall filter add action=log chain=input comment="Log SSH brute force attempts" dst-port=22 in-interface=ether1 log-prefix="SSH-ATTACK: " protocol=tcp

# Log Telnet access attempts from WAN
/ip firewall filter add action=log chain=input comment="Log Telnet attempts from WAN" dst-port=23 in-interface=ether1 log-prefix="TELNET-ATTACK: " protocol=tcp

# Log unauthorized web access from WAN
/ip firewall filter add action=log chain=input comment="Log unauthorized web access from WAN" dst-port=80,443,8080,8443 in-interface=ether1 log-prefix="WEB-ATTACK: " protocol=tcp

# Log unauthorized Winbox access from WAN
/ip firewall filter add action=log chain=input comment="Log unauthorized Winbox access from WAN" dst-port=8291 in-interface=ether1 log-prefix="WINBOX-ATTACK: " protocol=tcp

# Log port scanning attempts
/ip firewall filter add action=log chain=input comment="Log port scans (common ports)" dst-port=21,22,23,25,80,135,139,443,445,1433,3389,5432,8080,8443,3306 in-interface=ether1 log-prefix="PORT-SCAN: " protocol=tcp

# Log unauthorized management access
/ip firewall filter add action=log chain=input comment="Log management access from non-mgmt networks" dst-port=443,8291 in-interface=!vlan99-mgmt in-interface-list=LAN log-prefix="MGMT-VIOLATION: " protocol=tcp

# Drop all other traffic to router
/ip firewall filter add action=drop chain=input comment="Drop all other traffic to router"
```

### Forward Chain (Inter-VLAN Traffic)
```bash
# Allow established/related forwarded connections
/ip firewall filter add action=accept chain=forward comment="Allow established/related forwarded connections" connection-state=established,related

# Drop invalid forwarded connections
/ip firewall filter add action=drop chain=forward comment="Drop invalid forwarded connections" connection-state=invalid

# Block guest network from internal networks
/ip firewall filter add action=drop chain=forward comment="Block guest from internal networks" in-interface=vlan40-guest out-interface-list=LAN

# Allow bidirectional communication between LAN and Servers
/ip firewall filter add action=accept chain=forward comment="Allow LAN to Servers" in-interface=vlan10-lan out-interface=vlan20-servers
/ip firewall filter add action=accept chain=forward comment="Allow Servers to LAN" in-interface=vlan20-servers out-interface=vlan10-lan
```

### Chromecast/Streaming Device Rules
```bash
# Allow Chromecast control traffic from LAN to IoT
/ip firewall filter add action=accept chain=forward comment="Allow Chromecasts to send TCP traffic from ports 8008-8009 + 8443 to any port on any client on the Main LAN" dst-port=8008,8009,8443 in-interface=vlan10-lan out-interface=vlan30-iot protocol=tcp

# Allow Chromecast media streaming (LAN to IoT)
/ip firewall filter add action=accept chain=forward comment="Allow Chromecasts to send UDP traffic from ports 32768-61000 to any port on any client on the Main LAN" dst-port=32768-61000 in-interface=vlan10-lan out-interface=vlan30-iot protocol=udp

# Allow Chromecast media streaming (IoT to LAN)
/ip firewall filter add action=accept chain=forward comment="Allow Chromecasts to send UDP traffic from any port to ports 32768-61000 on any client on the Main LAN" dst-port=32768-61000 in-interface=vlan30-iot out-interface=vlan10-lan protocol=udp

# Allow Spotify Connect protocol
/ip firewall filter add action=accept chain=forward comment="Allow LAN to Spotify UDP port" dst-port=4070 in-interface=vlan10-lan out-interface=vlan30-iot protocol=udp
/ip firewall filter add action=accept chain=forward comment="Allow LAN to Spotify TCP port" dst-port=4070 in-interface=vlan10-lan out-interface=vlan30-iot protocol=tcp
```

#### Note: the above firewall rules were needed to allow casting to Chromecasts, Smart TVs, Google Home devices, etc.

### VPN and Management Access
```bash
# Allow VPN clients access to all internal networks
/ip firewall filter add action=accept chain=forward comment="Allow VPN clients to access LAN" in-interface=wireguard0 out-interface-list=LAN

# Allow internal networks access to VPN clients
/ip firewall filter add action=accept chain=forward comment="Allow LAN to access VPN clients" in-interface-list=LAN out-interface=wireguard0

# Allow management VLAN access to all networks
/ip firewall filter add action=accept chain=forward comment="Allow management to all internal networks" in-interface=vlan99-mgmt out-interface-list=LAN

# Allow all internal networks internet access
/ip firewall filter add action=accept chain=forward comment="Allow LAN networks to access internet" in-interface-list=LAN out-interface=ether1
```

### Final Security Rules
```bash
# Log guest network attempting internal access
/ip firewall filter add action=log chain=forward comment="Log guest VLAN attempting internal access" in-interface=vlan40-guest log-prefix="GUEST-VIOLATION: " out-interface-list=LAN

# Drop all other inter-VLAN traffic
/ip firewall filter add action=drop chain=forward comment="Drop all other inter-VLAN traffic" in-interface-list=LAN out-interface-list=LAN
```

---

## NAT Configuration

```bash
# Masquerade for internet access
/ip firewall nat add action=masquerade chain=srcnat out-interface=ether1

# NAT for WireGuard VPN clients
/ip firewall nat add action=masquerade chain=srcnat comment="NAT for WireGuard VPN clients" out-interface=ether1 src-address=10.100.100.0/24
```

---

## System Services

### Disabled Services (Security)
```bash
# Disable insecure services
/ip service set ftp disabled=yes
/ip service set ssh disabled=yes
/ip service set telnet disabled=yes
/ip service set www disabled=yes
/ip service set api disabled=yes
/ip service set api-ssl disabled=yes
```

### Certificate Settings
```bash
# Disable built-in certificate trust anchors
/certificate settings set builtin-trust-anchors=not-trusted
```

---

## Monitoring and Logging

### Network Discovery
```bash
# Disable neighbor discovery on dynamic interfaces
/ip neighbor discovery-settings set discover-interface-list=!dynamic
```

### System Configuration
```bash
# Set timezone
/system clock set time-zone-name=<TIMEZONE>

# Set router hostname
/system identity set name=<HOSTNAME>
```

### Netwatch Monitoring
```bash
# Monitor AdGuard Home availability and fallback to Google DNS
/tool netwatch add comment="AdGuard Home Monitor" disabled=no down-script="/ip dns set servers=8.8.8.8,1.1.1.1" host=<ADGUARD_IP> http-codes="" interval=1m test-script="" timeout=5s type=simple up-script="/ip dns set servers=<ADGUARD_IP>"
```

### Enable VLAN Filtering

```bash
/interface bridge
set bridge1 vlan-filtering=yes
```

**Important:** Enable VLAN filtering at the very end.

---

<br>
<br>

# TP-Link Managed Switch Configuration

## Port Configuration

| Port   | Description                                                                                                                                            | PVID | Notes                                                                         |
| ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------ | ---- | ----------------------------------------------------------------------------- |
| Port 3 | **Trunk** to unmanaged switch carrying: <br>• Untagged VLAN 10 (native) → for VLAN-unaware laptop <br>• Tagged VLAN 20 → for VLAN-aware Proxmox server | 10   | Both devices share same unmanaged switch; laptop = VLAN 10, Proxmox = VLAN 20 |
| Port 8 | Access port for VLAN 99 (management)                                                                                                                   | 99   | Used for switch/AP management access                                          |


-------

## VLAN Membership & Tagging


| VLAN            | Tagged Ports                        | Untagged Ports                      | Description                                          |
| --------------- | ----------------------------------- | ----------------------------------- | ---------------------------------------------------- |
| **10 – LAN**    | Ports 1, 2                          | **Port 3** (native VLAN for laptop) | Main LAN for laptop and general network devices      |
| **20 – Server** | Ports 1, **3** (tagged for Proxmox) | –                                   | Isolated server VLAN for Proxmox host/VMs            |
| **30 – IoT**    | Ports 1, 2                          | –                                   | IoT device network                                   |
| **40 – Guest**  | Ports 1, 2                          | –                                   | Guest Wi-Fi network                                  |
| **99 – Mgmt**   | Ports 1, 2                          | **Port 8**                          | Network for management interfaces (switch, AP, etc.) |