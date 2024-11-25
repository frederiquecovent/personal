# Cisco Cheat Sheet by Fréderique Covent

## 1. Basic Device Configuration

### Hostname and Password Configuration
- `hostname <name>` - Sets the device hostname.
- `enable secret <password>` - Configures an encrypted password for privileged exec mode.
- `service password-encryption` - Enables encryption of plaintext passwords in the configuration.
- `line console 0` - Enters console line configuration mode.
  - `password <password>` - Sets a password for console access.
  - `login` - Enables login on console.
- `line vty 0 4` - Configures virtual terminal lines (for Telnet/SSH).
  - `password <password>` - Sets a password for VTY access.
  - `login` - Enables login on VTY lines.
  - `transport input ssh` - Enables SSH

### Interface and IP Configuration
- `interface <type> <number>` - Enters interface configuration mode (ex. `interface g0/1`).
  - `ip address <ip> <subnet mask>` - Sets IP address and subnet mask on an interface.
  - `no shutdown` - Enables the interface.
- `show ip interface brief` - Displays IP addresses and status of all interfaces.
- `ip default-gateway <ip>` - Sets the default gateway for the device (important for routers in a switched network).

### Save and Verify Configuration
- `copy running-config startup-config` - Saves the running configuration to startup-config.
- `show running-config` - Displays the current active configuration.
- `show startup-config` - Displays the configuration saved in NVRAM.

## 2. Switching concepts

### Displaying and Verifying MAC Address Table
- `show mac address-table` - Displays the MAC address table.
- `show mac address-table dynamic` - Shows dynamically learned MAC addresses.
- `clear mac address-table dynamic` - Clears dynamic MAC addresses from the MAC address table.

### Port Security
- `interface <type> <number>` - Enters the interface configuration mode (e.g., `interface f0/1`).
  - `switchport mode access` - Sets the port to access mode.
  - `switchport port-security` - Enables port security on the interface.
  - `switchport port-security maximum <number>` - Limits the number of MAC addresses on the port.
  - `switchport port-security mac-address sticky` - Enables sticky MAC address learning.
  - `switchport port-security violation <protect|restrict|shutdown>` - Configures port violation mode.
- `show port-security` - Shows port security status for all interfaces.
- `show port-security interface <interface>` - Displays port security details for a specific interface.
- `clear port-security sticky` – Clears the sticky MAC addresses.


## 3. VLANs

### VLAN Creation and Assignment
- `vlan <vlan-id>` - Creates a new VLAN with the specified ID.
  - `name <vlan-name>` - Assigns a name to the VLAN.
- `interface <type> <number>` - Enters the interface configuration mode.
  - `switchport mode access` - Sets the port to access mode.
  - `switchport access vlan <vlan-id>` - Assigns the port to a specific VLAN.

### Trunking
- `interface <type> <number>` - Enters the interface configuration mode.
  - `switchport mode trunk` - Configures the port to trunk mode.
  - `switchport trunk allowed vlan <vlan-list>` - Specifies VLANs allowed on the trunk.
- `show interfaces trunk` - Displays trunk configuration details.

### VLAN Verification
- `show vlan` – Displays all VLANs configured on the switch (including active and allowed VLANs).
- `show vlan brief` - Shows a summary of all VLANs on the switch.
- `show interfaces vlan <vlan-id>` - Displays the status of a specific VLAN.
- `show interfaces <number> switchport` - Shows switchport information of a specific interface.

## 4. Inter-VLAN Routing

### Router-on-a-Stick Configuration

**1.** Create and name the VLANs </br>
**2.** Create the management interface </br>
**3.** Configure access ports </br>
**4.** Configure trunking ports  </br>

- `interface <interface>.<subinterface-number>` - Creates a subinterface (e.g., `g0/1.10`).
  - `encapsulation dot1Q <vlan-id>` - Configures VLAN tagging on the subinterface.
  - `ip address <ip> <subnet mask>` - Sets the IP address for the subinterface (gateway for the VLAN).

### Layer 3 Switch (SVI) Configuration

#### Switch configuration:
**1.** Create and name the VLANs </br>
**2.** Create the SVI VLAN interfaces </br>
**3.** Configure access ports </br>
**4.** Enable IP routing (`ip routing`) </br>

#### Routing configuration on a Layer 3 Switch:
**1.** Configure the routed port (`no switchport`) </br>
**2.** Assign an IP and subnet </br>
**3.** Enable the port </br>
**4.** Enable routing </br>
**5.** Configure routing (ex. static routing) </br>

- `interface vlan <vlan-id>` - Creates an SVI (Switch Virtual Interface) for VLAN.
  - `ip address <ip> <subnet mask>` - Assigns an IP to the VLAN interface.
  - `no shutdown` - Enables the SVI.

### Verification
- `show ip route` - Displays the routing table (to check if VLANs are reachable).
- `ping <ip-address>` - Verifies connectivity between VLANs.

## 5. STP Concepts

### De 4 stappen van STP
**1.** Bepaal de root bridge (switch met laagste Bridge ID) - `spanning-tree vlan [vlan_id] priority [priority_value]` </br> </br>
**2.** Bepaal de root ports (poort met laagste poortkosten bv. 19 bij 100 Mbps) - `spanning-tree vlan [vlan_id] cost [value]`  </br> </br>
**3.** Bepaal de designated ports  </br> </br>
**4.** Bepaal de alternate (blocked) ports  </br> </br>

### Troubleshooting 
- `show spanning-tree`
- `show spanning-tree vlan <id>`
- `show spanning-tree interface <id>`
- `show spanning-tree root`

### PortFast and BPDU Guard
**Enable portfast (only on access ports)**: `spanning-tree portfast` </br>
**Enable BPDU Guard (only on access ports)**: `spanning-tree bpduguard enable`

## 6. EtherChannel

### 1. ON
- ON - ON
- `int range <range>`
- `channel-group <id> mode on`
- `int port-channel <id>`
- `switchport mode trunk/access`

### 2. PAgP (Port Aggregation Protocol)
- DESIRABLE - DESIRABLE
- DESIRABLE - AUTO
- `int range <range>`
- `channel-group <id> mode auto/desirable`
- `int port-channel <id>`
- `switchport mode trunk/access`

### 3. LACP (Link aggregation Control Protocol)
- ACTIVE - ACTIVE
- ACTIVE - PASSIVE
- `int range <range>`
- `channel-group <id> mode active/passive`
- `int port-channel <id>`
- `switchport mode trunk/access`

### 4. Troubleshooting
- `show int port-channel`
- `show etherchannel summary`
- `show etherchannel port-channel`
- `show interfaces etherchannel`
- `show run`



## 7. DHCPv4

1. **Discover**: Client zendt een broadcast op zoek naar een DHCP-server.
2. **Offer**: DHCP-server biedt een IP-adres en andere configuratie-informatie aan.
3. **Request**: Client accepteert het aanbod door een verzoek te sturen naar de server.
4. **Acknowledge**: DHCP-server bevestigt het gebruik van de toegewezen configuratie.

### Router Configuratie
- `ip dhcp excluded-address 192.168.10.1`
- `ip dhcp pool <NAAM>`
  - `network 192.168.10.0 255.255.255.0`
  - `default-router 192.168.10.1`
  - `dns-server 192.168.11.5`
- `ip helper-address 10.0.0.1` (DHCP server in ander LAN)

## 8. SLAAC and DHCPv6

- **DEFAULT GATEWAY wordt automatisch bepaald door RA link-local adres, NIET DOOR DHCP**

### SLAAC:
1. **Router Solicitation**
2. **Router Advertisement**
   
### DHCP:
3. **SOLICIT** to all DHCPv6 Servers
4. **ADVERTISE** Unicast
5. **REQUEST** or **INFORMATION-REQUEST** Unicast
6. **REPLY** Unicast
   
### RA Flags
| A | O | M |              |
|---|---|---|--------------|
| 1 | 0 | 0 | SLAAC Only   |
| 1 | 1 | 0 | SLAAC + DHCP |
| 0 | X | 1 | DHCP Only    |

### Vereisten
1. **GUA**: `ipv6 address 2001:db8:acad:1::1/64`
2. **Link-local**: `ipv6 address fe80::1 link-local`
3. **All-nodes group (FF02::1)**
4. **All routers multicast group (FF02::2)**: `ipv6 unicast-routing`

### SLAAC Only (1 0 0)
#### Router configuratie
- `ipv6 unicast-routing`
- `interface <INTERFACE>`
  - `ipv6 address 2001:db8:acad:1::1/64`
  - `ipv6 enable`
  - `no ipv6 nd other-config-flag`
  - `no ipv6 nd managed-config-flag`
  - `no shutdown`

----------------------------------------------

### SLAAC + DHCP (1 1 0)
#### Router configuratie
- `ipv6 unicast-routing`
- `interface <INTERFACE>`
  - `ipv6 address 2001:db8:acad:1::1/64`
  - `ipv6 enable`
  - `ipv6 nd other-config-flag`
  - `no ipv6 nd managed-config-flag`
  - `no shutdown`

#### DHCP Server configuratie
- `ipv6 dhcp pool <POOL_NAAM>`
  - `dns-server 2001:db8:2::53`
  - `domain-name example.com`
- `interface <INTERFACE>`
  - `ipv6 dhcp server <POOL_NAAM>`
 
#### Router as client
- `ipv6 unicast-routing`
- `interface <INTERFACE>`
  - **`ipv6 address autoconfig`**
  - `ipv6 enable`
  - `ipv6 nd other-config-flag`
  - `no ipv6 nd managed-config-flag`
  - `no shutdown`


----------------------------------------------

### DHCP Only (0 X 1)
#### Router configuratie
- `ipv6 unicast-routing`
- `interface <INTERFACE>`
  - `ipv6 address 2001:db8:acad:1::1/64`
  - `ipv6 enable`
  - `ipv6 nd other-config-flag`
  - `ipv6 nd managed-config-flag`
  - `no shutdown`

#### DHCP Server configuratie
- `ipv6 dhcp pool <POOL_NAAM>`
  - `address prefix 2001:db8:acad:1::/64`
  - `dns-server 2001:db8:2::53`
  - `domain-name example.com`
`interface <INTERFACE>`
  - `ipv6 dhcp server <POOL_NAAM>`
 
#### Router as client
- `ipv6 unicast-routing`
- `interface <INTERFACE>`
  - **`ipv6 address dhcp`**
  - `ipv6 enable`
  - `ipv6 nd other-config-flag`
  - `ipv6 nd managed-config-flag`
  - `no shutdown`


## 14. Routing Concepts

### Letters in routing table
`L` = Address assigned to router interface </br>
`C` = Directly connected network </br>
`S` = Static route </br>
`O` = Dynamically learned </br>
`*` = Default route </br>

### Viewing Routing Information
- `show ip route` - Displays the routing table with all learned routes.
- `show ip protocols` - Shows routing protocols enabled on the router.

### Configuring Router Interfaces
- `interface <type> <number>` - Enters interface configuration mode.
  - `ip address <ip> <subnet mask>` - Sets the IP address on the router's interface.
  - `no shutdown` - Enables the interface.

## 15. IP Static Routing

### Standard Static Route
- `ip route <destination-network> <subnet mask> <next-hop-ip or exit-interface>` - Configures a static route.
  - Example: `ip route 192.168.1.0 255.255.255.0 10.1.1.2`

### Fully specified Static Route
- `ip route <destination-network> <subnet mask> <exit-interface> <next-hop-ip>` - Configures a fully specified static route.
  - Example: `ip route 192.168.1.0 255.255.255.0 GigabitEthernet 0/0/1 10.1.1.2`

- If next-hop is IPv6 link-local: **USE FULLY SPECIFIED!**

### Default Static Route
- `ip route 0.0.0.0 0.0.0.0 <next-hop-ip or exit-interface>` - Sets a default route (gateway of last resort).

### Floating Static Route (Backup path)
- `ip route 0.0.0.0 0.0.0.0 <next-hop-ip>` - Sets a default route (gateway of last resort).
- `ip route 0.0.0.0 0.0.0.0 <next-hop-ip> 5` - Sets a backup default route (gateway of last resort).


### Static Route Verification
- `show ip route` - Verifies static routes in the routing table.
- `show running-config | include ip route` - Displays all static routes in the configuration.
- `ping <destination IP>` - Tests connectivity to the destination network.

## 16. Troubleshoot Static and Default Routes

### Route Verification and Troubleshooting
- `show ip route` - Verifies if the route is in the routing table.
- `ping <destination-ip>` - Tests connectivity to the destination network.
- `traceroute <destination-ip>` - Tracks the path packets take to the destination.
- `show cdp neighbors detail` - Verifies connectivity to neighboring devices.
