output "public-interface-id" {
  value = azurerm_network_interface.public.id
}

output "private-interface-id" {
  value = azurerm_network_interface.internal.id
}
output "private_vm_addresses" {
  description = "List of private VM addresses return as list"
  value       = azurerm_linux_virtual_machine.web-server.private_ip_addresses
}

output "ip_configuration_name" {
  value = azurerm_network_interface.internal.ip_configuration[0].name
}

output "nginx-public-ip" {
  value = azurerm_linux_virtual_machine.web-server.public_ip_address
}