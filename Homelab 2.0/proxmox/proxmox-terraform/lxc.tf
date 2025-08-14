resource "proxmox_lxc" "container" {
  count        = var.lxc_count
  target_node  = var.target_node
  hostname     = "${var.lxc_name_prefix}${count.index + 1}"
  ostemplate   = var.lxc_template
  password     = var.lxc_password
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

  # SSH key setup
   provisioner "remote-exec" {
     inline = [
       "mkdir -p /root/.ssh",
       "echo '${file(var.lxc_ssh_pubkey)}' >> /root/.ssh/authorized_keys",
       "chmod 600 /root/.ssh/authorized_keys",
       "chmod 700 /root/.ssh"
     ]

     connection {
       type     = "ssh"
       user     = "root"
       password = var.container_password
       host     = self.network[0].ip
     }
   }
}