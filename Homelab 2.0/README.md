# Homelab 2.0

Demonstrating **enterprise-grade network security** and **infrastructure management**.

## Architecture Overview

**Homelab 2.0** consisting of:
- **MikroTik Router** - Router with VLAN segmentation and WireGuard VPN
- **TP-Link Managed Switch** - Managed switch for VLAN support
- **TP-Link Access Point** - Access point with VLAN tagging
- **Raspberry Pi** - Monitoring + DNS (AdGuard Home + Uptime Kuma)
- **Mini PC** - Proxmox Node for virtualization

## What's Included

### Network Infrastructure
- **VLAN Segmentation**: Separate networks for LAN, servers, IoT, guests, and management
- **WireGuard VPN**: Secure remote access with key-based authentication
- **Firewall Configuration**: Comprehensive security rules with logging
- **mDNS Bridging**: Enables casting between VLANs for IoT devices

### Services & Monitoring
- **AdGuard Home**: DNS ad-blocking and filtering
- **Uptime Kuma**: Service monitoring and uptime tracking
- **Caddy**: Reverse proxy for internal services
- **Proxmox**: Infrastructure as Code with Terraform for self-hosted applications

### Security Features
- **Guest Network Isolation**: Complete separation from internal resources
- **Management Network**: Dedicated VLAN for administrative access
- **Comprehensive Logging**: Security event monitoring and alerting
- **Default Deny Firewall**: Secure by default configuration