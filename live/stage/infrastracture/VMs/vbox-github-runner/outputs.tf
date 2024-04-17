output "proxmox_vm_ip_address" {
  value = module.proxmox_vm.ip_address
}

output "proxmox_dns_name" {
  value = mikrotik_dns_record.proxmox_vm.name
}
