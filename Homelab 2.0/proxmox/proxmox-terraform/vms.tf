resource "proxmox_vm_qemu" "vm" {
  count       = var.vm_count
  name        = "${var.vm_name_prefix}${count.index + 1}"
  target_node = var.target_node
  clone       = var.vm_template
  full_clone  = true
  agent       = 1

  # Resource allocation
  cores  = var.vm_cores
  memory = var.vm_memory

  # Disk
  disk {
    slot    = "scsi0"
    storage = var.storage_pool
    type    = "disk"
    size    = var.vm_disk_size
  }

  # Network
  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  # Cloud-init configuration
  ciuser     = var.vm_user
  cipassword = var.vm_password
  sshkeys    = file(var.vm_ssh_pubkey)

  # Boot settings
  boot = "cdn"

  # Don't start automatically
  onboot = false
}