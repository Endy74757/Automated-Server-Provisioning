output "vm_ips" {
  description = "Map of VM name to IPv4 address of adapter 0"
  value       = { for name, vm in virtualbox_vm.vm : 
                  name => vm.network_adapter[0].ipv4_address }
}


