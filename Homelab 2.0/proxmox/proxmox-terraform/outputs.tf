output "lxc_ips" {
  description = "IP addresses of created LXC containers"
  value = [
    for container in proxmox_lxc.container : {
      name = container.hostname
      ip   = container.network[0].ip
    }
  ]
}

output "vm_ips" {
  description = "IP addresses of created VMs"
  value = [
    for vm in proxmox_vm_qemu.vm : {
      name = vm.name
      ip   = vm.default_ipv4_address
    }
  ]
}
