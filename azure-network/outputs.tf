output "resource_group_name" {
  value = azurerm_resource_group.rg-nginx.name
}

output "resource_group_location" {
  value = azurerm_resource_group.rg-nginx.location
}

output "azure-public-subnet" {
  value = azurerm_subnet.public.id
}

output "azure-internal-subnet" {
  value = azurerm_subnet.internal.id
}