# Proxmox Connection Settings
proxmox_user     = "<USERNAME>"
proxmox_password = "<PASSWORD>"
target_node      = "proxmox"
storage_pool     = "local-lvm"

# LXC Container Configuration
lxc_count         = 0                   # Number of LXC containers to create
lxc_name_prefix   = "lxc-"
lxc_template      = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
lxc_cores         = 2
lxc_memory        = 1024                # MB
lxc_disk_size     = "10G"
lxc_password      = "<PASSWORD>"
lxc_ssh_pubkey  = "<PUBKEY_PATH>"

# VM Configuration (Template-based)
vm_count         = 0                    # Number of VMs to create
vm_name_prefix   = "vm-"
vm_template      = "ubuntu-server-template"
vm_cores         = 2
vm_memory        = 2048                 # MB
vm_disk_size     = "32G"                # Has to match template disk size