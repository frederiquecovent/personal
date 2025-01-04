# Cisco CCNA Cheat Sheet by Fréderique Covent

## 1. Basic Device Configuration

### Hostname and Password Configuration
* `hostname <name>` - Sets the device hostname
* `enable secret <password>` - Configures an encrypted password for privileged exec mode
* `service password-encryption` - Enables encryption of plaintext passwords in the configuration
* `banner motd #` - Sets a banner message
* `line console 0` - Enters console line configuration mode
  * `password <password>` - Sets a password for console access
  * `login` - Enables login on console
* `line vty 0 15` - Configures virtual terminal lines (for Telnet/SSH)
  * `password <password>` - Sets a password for VTY access
  * `login local` - Enables login using local database on VTY lines
  * `transport input ssh` - Enables SSH

### SSH Configuration Required Settings
* `ip ssh version 2`
* `crypto key generate rsa`
  * `1024`
* `username <username> secret <password>`

### Remote Management
* `int vlan <management vlan>`
  * `ip address x.x.x.x y.y.y.y`
  * `no shutdown`
* `ip default-gateway x.x.x.x`

### Interface and IP Configuration
* `interface <type> <number>` - Enters interface configuration mode (ex. `interface g0/1`)
  * `ip address <ip> <subnet mask>` - Sets IP address and subnet mask on an interface
  * `no shutdown` - Enables the interface
* `show ip interface brief` - Displays IP addresses and status of all interfaces
* `ip default-gateway <ip>` - Sets the default gateway for the device (important for routers in a switched network)

### Save and Verify Configuration
* `copy running-config startup-config` - Saves the running configuration to startup-config
* `show running-config` - Displays the current active configuration
* `show startup-config` - Displays the configuration saved in NVRAM

## 2. Switching Concepts

### Displaying and Verifying MAC Address Table
* `show mac address-table` - Displays the MAC address table
* `show mac address-table dynamic` - Shows dynamically learned MAC addresses
* `clear mac address-table dynamic` - Clears dynamic MAC addresses from the MAC address table

### Port Security
* `interface <type> <number>` - Enters the interface configuration mode (e.g., `interface f0/1`)
  * `switchport mode access` - Sets the port to access mode
  * `switchport port-security` - Enables port security on the interface
  * `switchport port-security maximum <number>` - Limits the number of MAC addresses on the port
  * `switchport port-security mac-address sticky` - Enables sticky MAC address learning
  * `switchport port-security violation <protect|restrict|shutdown>` - Configures port violation mode
* `show port-security` - Shows port security status for all interfaces
* `show port-security interface <interface>` - Displays port security details for a specific interface
* `clear port-security sticky` - Clears the sticky MAC addresses

## 3. VLANs

### VLAN Creation
* `vlan <vlan-id>` - Creates a new VLAN with the specified ID
  * `name <vlan-name>` - Assigns a name to the VLAN

### Access Ports
* `interface <type> <number>` - Enters the interface configuration mode
  * `switchport mode access` - Sets the port to access mode
  * `switchport access vlan <vlan-id>` - Assigns the port to a specific VLAN
  * `mls qos trust cos` - Sets quality of service
  * `switchport voice vlan <voice-vlan-id>` - Sets VOICE vlan

### Trunking
* `interface <type> <number>` - Enters the interface configuration mode
  * `switchport mode trunk` - Configures the port to trunk mode
  * `switchport trunk allowed vlan <vlan-list>` - Specifies VLANs allowed on the trunk
* `show interfaces trunk` - Displays trunk configuration details

### VLAN Management
* `no vlan <vlan-id>` - Deletes the VLAN
* `interface <type> <number>`
  * `no switchport access vlan` - Unassigns a port from VLAN
  * `no switchport trunk allowed vlan` - Removes allowed VLANs from trunk
  * `no switchport trunk native vlan` - Removes native VLAN configuration

### VLAN Verification
* `show vlan` - Displays all VLANs configured on the switch (including active and allowed VLANs)
* `show vlan brief` - Shows a summary of all VLANs on the switch
* `show interfaces vlan <vlan-id>` - Displays the status of a specific VLAN
* `show interfaces <number> switchport` - Shows switchport information of a specific interface

## 4. Inter-VLAN Routing

### Router-on-a-Stick Configuration

1. Create and name the VLANs
```
vlan <vlan-id>
name <vlan-name>
```

2. Create the management interface
```
interface vlan <vlan-id>
ip address <ip> <subnet mask>
no shutdown
```

3. Configure access ports
```
interface <interface-id>
switchport mode access
switchport access vlan <vlan-id>
```

4. Configure trunking ports
```
interface <interface-id>
switchport mode trunk
switchport trunk allowed vlan <vlan-id>,<vlan-id>
```

5. Configure subinterfaces
```
interface <interface>.<subinterface-number>
encapsulation dot1Q <vlan-id> (native)
ip address <ip> <subnet mask>
```

6. Turn the interface on
```
interface <interface>
no shutdown
```

### Layer 3 Switch (SVI) Configuration

#### Switch Configuration
1. Create and name the VLANs
```
vlan <vlan-id>
name <vlan-name>
```

2. Create the SVI VLAN interfaces
```
interface vlan <vlan-id>
ip address <ip> <subnet mask>
no shutdown
```

3. Configure access ports
```
interface <interface-id>
switchport mode access
switchport access vlan <vlan-id>
```

4. Configure trunking ports
```
interface <interface-id>
switchport mode trunk
switchport trunk encapsulation dot1q
(switchport trunk native vlan <vlan-id>)
```

5. Enable IP routing
```
ip routing
```

#### Routing Configuration on Layer 3 Switch
1. Configure the routed port
```
interface <interface-id>
no switchport
ip address <ip> <subnet mask>
no shutdown
```

2. Configure routing (ex. static routing)

### Verification
* `show ip route` - Displays the routing table (to check if VLANs are reachable)
* `ping <ip-address>` - Verifies connectivity between VLANs

## 5. STP Concepts

### STP Steps
1. Determine root bridge (switch with lowest Bridge ID)
   * `spanning-tree vlan [vlan_id] priority [priority_value]`
   * `spanning-tree vlan [vlan_id] root primary`

2. Determine root ports (port with lowest port cost, e.g., 19 for 100 Mbps)
   * `spanning-tree vlan [vlan_id] cost [value]`

3. Determine designated ports

4. Determine alternate (blocked) ports

### Troubleshooting
* `show spanning-tree`
* `show spanning-tree vlan <id>`
* `show spanning-tree interface <id>`
* `show spanning-tree root`

### PortFast and BPDU Guard
* Enable PortFast (only on access ports): `spanning-tree portfast`
* Enable BPDU Guard (only on access ports): `spanning-tree bpduguard enable`

## 6. EtherChannel

### 1. ON Configuration
* ON - ON configuration:
```
interface range <range>
  switchport mode trunk
  shutdown
  channel-group <id> mode on
  no shutdown

interface port-channel <id>
  switchport mode trunk
  switchport trunk allowed vlan <id>,<id>
```

### 2. PAgP (Port Aggregation Protocol)
* DESIRABLE - DESIRABLE or DESIRABLE - AUTO configuration:
```
interface range <range>
  switchport mode trunk
  shutdown
  channel-group <id> mode auto/desirable
  no shutdown

interface port-channel <id>
  switchport mode trunk
  switchport trunk allowed vlan <id>,<id>
```

### 3. LACP (Link Aggregation Control Protocol)
* ACTIVE - ACTIVE or ACTIVE - PASSIVE configuration:
```
interface range <range>
  switchport mode trunk
  shutdown
  channel-group <id> mode active/passive
  no shutdown

interface port-channel <id>
  switchport mode trunk
  switchport trunk allowed vlan <id>,<id>
```

### 4. Troubleshooting
* `show int port-channel`
* `show etherchannel summary`
* `show etherchannel port-channel`
* `show interfaces etherchannel`
* `show run`

## 7. DHCPv4

### DHCP Process
1. **Discover**: Client broadcasts looking for DHCP server
2. **Offer**: DHCP server offers IP address and configuration
3. **Request**: Client accepts offer by sending request
4. **Acknowledge**: DHCP server confirms configuration

### Router Configuration
* `ip dhcp excluded-address 192.168.10.1`
* `ip dhcp pool <NAAM>`
  * `network 192.168.10.0 255.255.255.0`
  * `default-router 192.168.10.1`
  * `dns-server 192.168.11.5`
* `ip helper-address 10.0.0.1` (DHCP server in other LAN)

### Router as Client
* `interface <INTERFACE>`
  * `ip address dhcp`
  * `no shutdown`

## 8. SLAAC and DHCPv6

### Important Note
* Default gateway is automatically determined by RA link-local address, NOT BY DHCP

### Process Overview
#### SLAAC
1. Router Solicitation
2. Router Advertisement

#### DHCP
3. SOLICIT to all DHCPv6 Servers
4. ADVERTISE Unicast
5. REQUEST or INFORMATION-REQUEST Unicast
6. REPLY Unicast

### RA Flags
| A | O | M | Mode         |
|---|---|---|--------------|
| 1 | 0 | 0 | SLAAC Only  |
| 1 | 1 | 0 | SLAAC + DHCP|
| 0 | X | 1 | DHCP Only   |

### Requirements
1. **GUA**: `ipv6 address 2001:db8:acad:1::1/64`
2. **Link-local**: `ipv6 address fe80::1 link-local`
3. **Multicast groups**: `ipv6 unicast-routing`
   * All-nodes group (FF02::1)
   * All routers multicast group (FF02::2)

### Configuration Types

#### SLAAC Only (1 0 0)
Router Configuration:
```
ipv6 unicast-routing
interface <INTERFACE>
  ipv6 address 2001:db8:acad:1::1/64
  ipv6 enable
  no ipv6 nd other-config-flag
  no ipv6 nd managed-config-flag
  no shutdown
```

#### SLAAC + DHCP (1 1 0)
Router Configuration:
```
ipv6 unicast-routing
interface <INTERFACE>
  ipv6 address 2001:db8:acad:1::1/64
  ipv6 enable
  ipv6 nd other-config-flag
  no ipv6 nd managed-config-flag
  no shutdown
```

DHCP Server Configuration:
```
ipv6 dhcp pool <POOL_NAAM>
  dns-server 2001:db8:2::53
  domain-name example.com
interface <INTERFACE>
  ipv6 dhcp server <POOL_NAAM>
```

Router as Client:
```
ipv6 unicast-routing
interface <INTERFACE>
  ipv6 enable
  ipv6 address autoconfig
  no shutdown
```

#### DHCP Only (0 X 1)
Router Configuration:
```
ipv6 unicast-routing
interface <INTERFACE>
  ipv6 address 2001:db8:acad:1::1/64
  ipv6 enable
  ipv6 nd other-config-flag
  ipv6 nd managed-config-flag
  no shutdown
```

DHCP Server Configuration:
```
ipv6 dhcp pool <POOL_NAAM>
  address prefix 2001:db8:acad:1::/64
  dns-server 2001:db8:2::53
  domain-name example.com
interface <INTERFACE>
  ipv6 dhcp server <POOL_NAAM>
```

Router as Client:
```
ipv6 unicast-routing
interface <INTERFACE>
  ipv6 enable
  ipv6 address dhcp
  no shutdown
```

## 9. FHRP (HSRP)

### Basic Configuration
```
interface <interface-id>
  standby version 2
  ip address <real-ip> <subnet-mask>
  standby <group-number> ip <virtual-ip>
```

### Additional Settings
* Set priority: `standby <group-number> priority <0-150>`
* Enable preemption: `standby <group-number> preempt`

## 14. Routing Concepts

### Route Types in Routing Table
* `L` = Address assigned to router interface
* `C` = Directly connected network
* `S` = Static route
* `O` = Dynamically learned
* `*` = Default route

### Viewing Routing Information
* `show ip route` - Displays the routing table with all learned routes
* `show ip protocols` - Shows routing protocols enabled on the router

### Configuring Router Interfaces
* `interface <type> <number>` - Enters interface configuration mode
  * `ip address <ip> <subnet mask>` - Sets the IP address on the router's interface
  * `no shutdown` - Enables the interface

## 15. IP Static Routing

### Standard Static Route
* `ip route <destination-network> <subnet mask> <next-hop-ip or exit-interface>`
  * Example: `ip route 192.168.1.0 255.255.255.0 10.1.1.2`

### Fully Specified Static Route
* `ip route <destination-network> <subnet mask> <exit-interface> <next-hop-ip>`
  * Example: `ip route 192.168.1.0 255.255.255.0 GigabitEthernet 0/0/1 10.1.1.2`
* Note: If next-hop is IPv6 link-local, use fully specified route

### Default Static Route
* IPv4: `ip route 0.0.0.0 0.0.0.0 <next-hop-ip or exit-interface>`
* IPv6: `::/0`

### Floating Static Route (Backup Path)
* Primary: `ip route 0.0.0.0 0.0.0.0 <next-hop-ip>`
* Backup: `ip route 0.0.0.0 0.0.0.0 <next-hop-ip> 5`

### Static Route Verification
* `show ip route` - Verifies static routes in the routing table
* `show running-config | include ip route` - Displays all static
