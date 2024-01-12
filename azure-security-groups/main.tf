resource "azurerm_network_security_group" "vm-sg-ssh" {
  name                = "vm-public-ssh-access"
  resource_group_name = var.azure-rg-name
  location            = var.location
}
resource "azurerm_network_interface_security_group_association" "public-ssh" {
  network_interface_id      = var.public-interface-id
  network_security_group_id = azurerm_network_security_group.vm-sg-ssh.id
}

resource "azurerm_network_security_group" "vm-sg-http" {
  name                = "vm-internal-http-access"
  resource_group_name = var.azure-rg-name
  location            = var.location
}
resource "azurerm_network_interface_security_group_association" "private-http" {
  network_interface_id      = var.private-interface-id
  network_security_group_id = azurerm_network_security_group.vm-sg-http.id
}


resource "azurerm_network_security_rule" "vm-internal-http-access" {
  name                        = "httpAcees"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = 80
  source_address_prefix       = "*"
  destination_address_prefix  = var.private_vm_addresses[1]
  resource_group_name         = var.azure-rg-name
  network_security_group_name = azurerm_network_security_group.vm-sg-http.name
}

resource "azurerm_network_security_rule" "vm-public-ssh-access" {
  name                        = "sshAccess"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = 22
  source_address_prefix       = "*"
  destination_address_prefix  = var.private_vm_addresses[0]
  resource_group_name         = var.azure-rg-name
  network_security_group_name = azurerm_network_security_group.vm-sg-ssh.name
}