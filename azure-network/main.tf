resource "azurerm_resource_group" "rg-nginx" {
  name     = "${var.prefix}-group"
  location = var.location
}
resource "azurerm_virtual_network" "nginx-vnet" {
  name                = "${var.prefix}-network"
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.rg-nginx.location
  resource_group_name = azurerm_resource_group.rg-nginx.name
}
resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg-nginx.name
  virtual_network_name = azurerm_virtual_network.nginx-vnet.name
  address_prefixes     = var.internal_address_prefixes
}

resource "azurerm_subnet" "public" {
  name                 = "public"
  resource_group_name  = azurerm_resource_group.rg-nginx.name
  virtual_network_name = azurerm_virtual_network.nginx-vnet.name
  address_prefixes     = var.public_address_prefixes
}