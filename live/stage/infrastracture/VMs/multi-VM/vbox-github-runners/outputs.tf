# output "proxmox_vm_ip_address" {
#   value = module.proxmox_vm.ip_address
# }

# output "proxmox_dns_name" {
#   value = mikrotik_dns_record.proxmox_vm.name
# }

output "ansible-command" {
  description = "You can run ansible playbook with that command"
  value       = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ${var.ssh_user} -i ansible/hosts.cfg modules/ansible/github-runner/main.yml"
}
