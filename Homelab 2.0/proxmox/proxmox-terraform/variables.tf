# General Variables
variable "proxmox_user" {
  description = "Proxmox username"
  type        = string
}

variable "proxmox_password" {
  description = "Proxmox password"
  type        = string
  sensitive   = true
}

variable "target_node" {
  description = "Target Proxmox node"
  type        = string
}

variable "storage_pool" {
  description = "Storage pool to use"
  type        = string
}


# LXC Variables
variable "lxc_count" {
  description = "Number of LXC containers to create"
  type        = number
}

variable "lxc_name_prefix" {
  description = "Prefix for LXC container names"
  type        = string
}

variable "lxc_template" {
  description = "LXC template to use"
  type        = string
}

variable "lxc_cores" {
  description = "CPU cores for LXC containers"
  type        = number
}

variable "lxc_memory" {
  description = "Memory for LXC containers (MB)"
  type        = number
}

variable "lxc_disk_size" {
  description = "Disk size for LXC containers"
  type        = string
}

variable "lxc_password" {
  description = "Password for LXC containers"
  type        = string
  sensitive   = true
}

variable "lxc_ssh_pubkey" {
  description = "Path to SSH public key for LXC login"
  type        = string
  sensitive   = true
}


# VM Variables
variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
}

variable "vm_name_prefix" {
  description = "Prefix for VM names"
  type        = string
}

variable "vm_template" {
  description = "Proxmox VM template to clone"
  type        = string
}

variable "vm_cores" {
  description = "CPU cores for VMs"
  type        = number
}

variable "vm_memory" {
  description = "Memory for VMs (MB)"
  type        = number
}

variable "vm_disk_size" {
  description = "Disk size for VMs - Has to match template disk size"
  type        = string
}