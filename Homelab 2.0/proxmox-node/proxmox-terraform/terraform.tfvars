# Proxmox Connection Settings
proxmox_user     = "<USERNAME>"
proxmox_password = "<PASSWORD>"
target_node      = "proxmox"
storage_pool     = "local-lvm"

# LXC per-container configuration
lxc_names       = ["docker-host", "monitoring"]
lxc_template    = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
lxc_cores       = [1, 2]
lxc_memory      = [2048, 4096]
lxc_disk_sizes  = ["16G", "32G"]
lxc_password    = "<DEFAULT_PASSWORD>"
lxc_ssh_pubkey  = "<PATH_TO_PUBKEY>"

# VM Configuration (Template-based)
vm_names      = ["webserver"]
vm_template   = "ubuntu-server-template"
vm_cores      = [2]
vm_memory     = [4096]
vm_disk_size  = "32G"                # Has to match template disk size