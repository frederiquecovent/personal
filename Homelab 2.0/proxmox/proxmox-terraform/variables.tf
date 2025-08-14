# General Variables
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

variable "storage_pool" {
  description = "Storage pool to use"
  type        = string
  default     = "local-lvm"
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

variable "lxc_password" {
  description = "Password for LXC containers"
  type        = string
  sensitive   = true
  default     = "changeme"
}

variable "lxc_ssh_pubkey" {
  description = "Path to SSH public key for LXC login"
  type        = string
  default     = "<PUBLIC_KEY>"
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

variable "vm_template" {
  description = "Proxmox VM template to clone"
  type        = string
  default     = "ubuntu-cloud-template"
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

variable "vm_user" {
  description = "Username for the VM"
  type        = string
  default     = "ubuntu"
}

variable "vm_password" {
  description = "Password for the VM"
  type        = string
  sensitive   = true
  default     = "changeme"
}

variable "vm_ssh_pubkey" {
  description = "Path to SSH public key for VM login"
  type        = string
  default     = "<PUBLIC_KEY>"
}
