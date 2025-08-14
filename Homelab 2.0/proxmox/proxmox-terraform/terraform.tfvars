# Proxmox Connection Settings
proxmox_user     = "<USERNAME>"
proxmox_password = "<PASSWORD>"
target_node      = "<PROXMOX_NODE>"
storage_pool     = "local-lvm"

# LXC Container Configuration
lxc_count         = 0                   # Number of LXC containers to create
lxc_cores         = 2
lxc_memory        = 1024                # MB
lxc_disk_size     = "10G"

# VM Configuration (Template-based)
vm_count         = 0                    # Number of VMs to create
vm_cores         = 2
vm_memory        = 2048                 # MB
vm_disk_size     = "25G"