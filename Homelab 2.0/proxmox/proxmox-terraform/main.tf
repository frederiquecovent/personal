# Terraform configuration for Proxmox
terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc03"
    }
  }
}

# Provider configuration
provider "proxmox" {
  pm_api_url      = "https://<PROXMOX_IP>:8006/api2/json"
  pm_user         = var.proxmox_user
  pm_password     = var.proxmox_password
  pm_tls_insecure = true
  pm_minimum_permission_check = false
}

# Variables
variable "proxmox_user" {
  description = "Proxmox username (e.g., root@pam)"
  type        = string
  default     = "root@pam"
}

variable "proxmox_password" {
  description = "Proxmox password"
  type        = string
  sensitive   = true
}

variable "target_node" {
  description = "Target Proxmox node"
  type        = string
  default     = "proxmox"
}

# LXC Container
resource "proxmox_lxc" "container" {
  count        = var.lxc_count
  target_node  = var.target_node
  hostname     = "${var.lxc_name_prefix}${count.index + 1}"
  ostemplate   = var.lxc_template
  password     = var.container_password
  unprivileged = true
  start        = true

  # Resource allocation
  cores  = var.lxc_cores
  memory = var.lxc_memory

  # Root filesystem
  rootfs {
    storage = var.storage_pool
    size    = var.lxc_disk_size
  }

  # Network
  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "dhcp"
  }
}

# Virtual Machine
resource "proxmox_vm_qemu" "vm" {
  count       = var.vm_count
  name        = "${var.vm_name_prefix}${count.index + 1}"
  target_node = var.target_node
  agent       = 1

  # Resource allocation
  cpu {
    cores   = var.vm_cores
    sockets = 1
  }
  memory = var.vm_memory

  # Disk
  disk {
    slot    = "scsi0"
    storage = var.storage_pool
    type    = "disk"
    size    = var.vm_disk_size
  }


  # ISO attachment
  disk {
    type    = "cdrom"
    iso     = var.vm_iso
    slot    = "ide2"
  }


  # Network
  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  # Boot settings
  boot = "cdn"

  # Don't start automatically
  onboot = false
}

# LXC Variables
variable "lxc_count" {
  description = "Number of LXC containers to create"
  type        = number
  default     = 0
}

variable "lxc_name_prefix" {
  description = "Prefix for LXC container names"
  type        = string
  default     = "lxc-"
}

variable "lxc_template" {
  description = "LXC template to use"
  type        = string
  default     = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
}

variable "container_password" {
  description = "Password for LXC containers"
  type        = string
  sensitive   = true
  default     = "changeme"
}

variable "lxc_cores" {
  description = "CPU cores for LXC containers"
  type        = number
  default     = 1
}

variable "lxc_memory" {
  description = "Memory for LXC containers (MB)"
  type        = number
  default     = 512
}

variable "lxc_disk_size" {
  description = "Disk size for LXC containers"
  type        = string
  default     = "8G"
}

# VM Variables
variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 0
}

variable "vm_name_prefix" {
  description = "Prefix for VM names"
  type        = string
  default     = "vm-"
}

variable "vm_iso" {
  description = "ISO image for VMs"
  type        = string
  default     = "local:iso/ubuntu-22.04.5-live-server-amd64.iso"
}

variable "vm_cores" {
  description = "CPU cores for VMs"
  type        = number
  default     = 2
}

variable "vm_memory" {
  description = "Memory for VMs (MB)"
  type        = number
  default     = 2048
}

variable "vm_disk_size" {
  description = "Disk size for VMs"
  type        = string
  default     = "20G"
}

# Storage
variable "storage_pool" {
  description = "Storage pool to use"
  type        = string
  default     = "local-lvm"
}

# Outputs
output "lxc_ips" {
  description = "IP addresses of created LXC containers"
  value = [
    for container in proxmox_lxc.container : {
      name = container.hostname
      ip   = container.network[0].ip
    }
  ]
}

output "vm_names" {
  description = "Names of created VMs"
  value       = [for vm in proxmox_vm_qemu.vm : vm.name]
}