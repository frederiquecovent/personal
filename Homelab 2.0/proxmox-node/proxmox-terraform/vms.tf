resource "proxmox_vm_qemu" "vm" {
  count       = length(var.vm_names)
  name        = var.vm_names[count.index]
  target_node = var.target_node
  clone       = var.vm_template
  full_clone  = true
  agent       = 1

  # Resource allocation
  cpu {
    cores = var.vm_cores[count.index]
  }
  memory = var.vm_memory[count.index]

  # Main disk - cloned from template
  disks {
    scsi {
      scsi0 {
        disk {
          size    = var.vm_disk_size
          storage = var.storage_pool
        }
      }
    }
  }

  # Network
  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  # Don't start automatically
  onboot = false
}