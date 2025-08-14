# Proxmox credentials
proxmox_user     = "<USERNAME>"
proxmox_password = "<PASSWORD>"

# Target node
target_node = "proxmox"

# Storage pool
storage_pool = "local-lvm"

# LXC Configuration
lxc_count         = 0                      # Number of LXCs to create
#lxc_name_prefix   = "ubuntu-"
lxc_template      = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
container_password = "<DEFAULT_PASSWORD>"  # Enable SSH with keys after creation
lxc_cores         = 2
lxc_memory        = 1024                   # MB
lxc_disk_size     = "10G"

# VM Configuration
vm_count       = 0                        # Number of VMs to create (set to 0 to skip VMs)
#vm_name_prefix = "server-"
vm_iso         = "local:iso/ubuntu-22.04.5-live-server-amd64.iso"
vm_cores       = 2
vm_memory      = 2048                     # MB
vm_disk_size   = "25G"