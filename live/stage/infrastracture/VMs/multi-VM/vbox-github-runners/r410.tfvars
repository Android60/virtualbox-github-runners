virtual_machines = {
  vm1 = { name = "r410-vbox-github-runner-1.server" },
  vm2 = { name = "r410-vbox-github-runner-2.server" },
  #   vm3 = { name = "tf-webserver3" }
}
target_node  = "dell-r410"
storage_pool = "local-lvm"
