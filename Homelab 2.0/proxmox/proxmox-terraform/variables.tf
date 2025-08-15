# General
variable "proxmox_user" { type = string }
variable "proxmox_password" { type = string, sensitive = true }
variable "target_node" { type = string }
variable "storage_pool" { type = string }


# LXC Configuration
variable "lxc_names" { type = list(string) }
variable "lxc_template" { type = string }
variable "lxc_cores" { type = list(number) }
variable "lxc_memory" { type = list(number) }      # MB
variable "lxc_disk_sizes" { type = list(string) }  # e.g., ["20G", "50G"]
variable "lxc_password" { type = string }
variable "lxc_ssh_pubkey" { type = string }


# VM Configuration
variable "vm_names" { type = list(string) }
variable "vm_template" { type = string }
variable "vm_cores" { type = list(number) }
variable "vm_memory" { type = list(number) }       # MB
variable "vm_disk_size" { type = string}           # Needs to match template disk size