variable "project_name" {
  description = "A short name for this project"
  type        = string
  default     = "automated-server-provisioning"
}



variable "vm_names" {
  description = "List of VM names to create (use this for multiple VMs)"
  type        = list(string)
  default     = ["webserver-01", "docker-01", "k8s"]
}

variable "vm_cpus" {
  description = "Number of vCPUs for the VM"
  type        = number
  default     = 2
}

variable "vm_memory" {
  description = "RAM for the VM (e.g., '1024 mib', '2 gib')"
  type        = string
  default     = "1024 mib"
}

variable "vm_image" {
  description = "URL or path to a .box image for VirtualBox"
  type        = string
  default     = "https://app.vagrantup.com/ubuntu/boxes/bionic64/versions/20180903.0.0/providers/virtualbox.box"
}

variable "vm_host_interface" {
  description = "Name of the VirtualBox Host-Only adapter (e.g., 'VirtualBox Host-Only Ethernet Adapter')"
  type        = string
  default     = "VirtualBox Host-Only Ethernet Adapter #2"
}

variable "boot_wait_seconds" {
  description = "Seconds to wait after each VM is created to allow boot to finish"
  type        = number
  default     = 60
}

variable "ssh_public_key" {
  type    = string
  default = "C:/Users/ASUS/.ssh/id_rsa.pub"
}

