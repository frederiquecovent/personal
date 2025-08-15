resource "proxmox_lxc" "container" {
  count        = length(var.lxc_names)
  target_node  = var.target_node
  hostname     = var.lxc_names[count.index]
  ostemplate   = var.lxc_template
  password     = var.lxc_password
  unprivileged = false        # NOTE: PRIVILEGED CONTAINER!
  start        = true

  # Resource allocation
  cores  = var.lxc_cores[count.index]
  memory = var.lxc_memory[count.index]

  # Root filesystem
  rootfs {
    storage = var.storage_pool
    size    = var.lxc_disk_sizes[count.index]
  }

  # Network
  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "dhcp"
  }

  # Fix SSH and setup keys via Proxmox host
  provisioner "local-exec" {
    command = <<-EOT
      sleep 20
      sudo pct exec ${self.vmid} -- bash -c '
        sed -i "s/#*PermitRootLogin.*/PermitRootLogin yes/" /etc/ssh/sshd_config
        systemctl restart ssh || systemctl restart sshd
        mkdir -p /root/.ssh
        chmod 700 /root/.ssh
      '
      sudo pct exec ${self.vmid} -- bash -c 'echo "${file(var.lxc_ssh_pubkey)}" >> /root/.ssh/authorized_keys'
      sudo pct exec ${self.vmid} -- bash -c 'chmod 600 /root/.ssh/authorized_keys'
      sudo pct exec ${self.vmid} -- bash -c '
        sed -i "s/PermitRootLogin yes/PermitRootLogin prohibit-password/" /etc/ssh/sshd_config
        systemctl restart ssh || systemctl restart sshd
      '
    EOT
  }
}