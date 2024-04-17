# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------
variable "vm_name" {
  description = "The name of the VM that will be created"
  type        = string
  default     = "vbox-github-runner.server"
}

variable "target_node" {
  description = "The node to use when creating VM"
  type        = string
  default     = "megaserver-proxmox"
}

variable "clone_template" {
  description = "The base VM from which to clone to create the new VM"
  type        = number
  default     = 212
}

variable "ssh_user" {
  description = "User to use for SSH"
  type        = string
  default     = "debian"
}

variable "disk_size" {
  description = "The size of the created disk"
  type        = number
  default     = "64"
}

variable "storage_pool" {
  description = "The name of the storage pool on which to store the disk."
  type        = string
  default     = "hdd_lvm"
}

variable "virtual_machines" {
  description = "Map for VMs names and configuration"
  type        = map(any)
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
variable "remote_exec" {
  description = "Script to run"
  type        = list(string)
  default     = ["echo \"Hello, World from $(uname -smp)\""]
}

variable "description" {
  description = "The description for the VM that will be created"
  type        = string
  default     = "Managed by Terraform"
}

variable "env" {
  description = "Environment for VM name"
  type        = string
  default     = "stage"
}

locals {
  vm_name = "${var.env}.${var.vm_name}"
}
