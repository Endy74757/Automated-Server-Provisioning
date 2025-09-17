provider "virtualbox" {}
provider "time" {}

resource "virtualbox_vm" "vm" {
  for_each = toset(var.vm_names)

  name   = each.key
  image  = var.vm_image
  cpus   = var.vm_cpus
  memory = var.vm_memory

  network_adapter {
    type           = "nat"
  }

  network_adapter {
    type           = "hostonly"
    host_interface = var.vm_host_interface
  }
}

# Wait after each VM creation to allow OS to boot
# resource "time_sleep" "boot_wait" {
#   for_each       = virtualbox_vm.vm
#   create_duration = "${var.boot_wait_seconds}s"
#   depends_on     = [virtualbox_vm.vm]
# }





