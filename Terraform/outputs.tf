output "web_ips" {
  description = "Map of VM name to IPv4 address of adapter 0"
  value       = { for name, vm in virtualbox_vm.web : 
                  name => vm.network_adapter[0].ipv4_address }
}

output "control_ips" {
  description = "Map of VM name to IPv4 address of adapter 0"
  value       = { for name, vm in virtualbox_vm.control : 
                  name => vm.network_adapter[0].ipv4_address }
}

