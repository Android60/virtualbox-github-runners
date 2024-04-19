terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.48.1"
    }
    mikrotik = {
      source  = "ddelnano/mikrotik"
      version = "0.9.1"
    }

  }
}

provider "proxmox" {

}

provider "mikrotik" {
  #set MIKROTIK_HOST environment variable
  # export MIKROTIK_USER=user
  # export MIKROTIK_PASSWORD=pass
  tls      = false # Or set MIKROTIK_TLS environment variable
  insecure = true  # Or set MIKROTIK_INSECURE environment variable
}

module "proxmox_vm" {
  source         = "git::https://gitlab.myhomelab.xyz/terraform-modules/terraform-proxmox-modules.git//modules/vm-module/?ref=v0.1.5"
  for_each       = var.virtual_machines
  name           = "${var.env}-${each.value.name}" # Name for new VM
  target_node    = var.target_node                 # Create VM on that node
  clone_template = var.clone_template              # Template to use when cloning VM
  remote_exec    = var.remote_exec                 # Script to execute on provisioning
  ssh_privkey    = file("~/.ssh/id_rsa")           # Private key to use when provisioning
  ssh_user       = var.ssh_user                    # SSH user to use
  ciuser         = var.ssh_user
  ssh_keys       = [trimspace(file("~/.ssh/id_rsa.pub"))]
  cores          = 4
  memory         = 6144
  vlan           = 50
  storage_pool   = var.storage_pool
  disk_size      = var.disk_size
  tags           = ["prod", "terraform"]
  user           = " "
  nameserver     = ["10.1.50.1"]
}

resource "null_resource" "ansible-provisioner" {
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ${var.ssh_user} -i ansible/hosts.cfg modules/ansible/github-runner/main.yml"
  }
  triggers = {
    ansible_playbook = filesha256("modules/ansible/github-runner/main.yml")
  }
  depends_on = [
    module.proxmox_vm,
    local_file.hosts_cfg
  ]
  provisioner "local-exec" {
    when    = destroy
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -e 'runner_state=absent' -i ansible/hosts.cfg modules/ansible/github-runner/main.yml"
  }
}

resource "mikrotik_dns_record" "proxmox_vm" {
  for_each = module.proxmox_vm
  name     = "${var.env}.${each.value.name}"
  address  = each.value.ip_address[0]
  ttl      = 86400
}


# generate inventory file for Ansible
resource "local_file" "hosts_cfg" {
  depends_on = [module.proxmox_vm]
  content = templatefile("${path.module}/templates/hosts.tpl",
    {
      #servers = slice(split("/",(values(proxmox_lxc.webservers-lxc)[*].network[0].ip)[0]), 0, 1)
      servers      = { for k, inst in module.proxmox_vm : k => inst.ip_address[0] }
      ansible_user = var.ssh_user
    }
  )
  filename = "ansible/hosts.cfg"
}
