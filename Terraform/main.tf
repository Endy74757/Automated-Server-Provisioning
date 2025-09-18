provider "virtualbox" {}
provider "time" {}

resource "virtualbox_vm" "web" {
  count = 2

  name   = format("web-%02d", count.index + 1)
  image  = var.vm_image
  cpus   = var.vm_cpus
  memory = var.vm_memory
  user_data = file("${path.module}/user_data.txt")

  network_adapter {
    type           = "hostonly"
    host_interface = var.vm_host_interface
  }
}

resource "virtualbox_vm" "control" {
  count = 1

  name   = format("control-%02d", count.index + 1)
  image  = var.vm_image
  cpus   = var.vm_cpus
  memory = var.vm_memory
  user_data = file("${path.module}/user_data.txt")

  network_adapter {
    type           = "hostonly"
    host_interface = var.vm_host_interface
  }
}