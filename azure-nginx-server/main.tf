### Internal interface
resource "azurerm_network_interface" "internal" {
  name                = "${var.prefix}-private-nic"
  resource_group_name = var.azure-rg-name
  location            = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.internal_subnet
    private_ip_address_allocation = "Dynamic"
  }
}
## Public interface
resource "azurerm_public_ip" "vm-publicIP" {
  name                = "${var.prefix}-pip"
  resource_group_name = var.azure-rg-name
  location            = var.location
  allocation_method   = "Static"
}
resource "azurerm_network_interface" "public" {
  name                = "${var.prefix}-public-nic"
  resource_group_name = var.azure-rg-name
  location            = var.location

  ip_configuration {
    name                          = "public"
    subnet_id                     = var.public_subnet
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm-publicIP.id
  }
}
### ubuntu VMß
resource "azurerm_linux_virtual_machine" "web-server" {
  name                            = "${var.prefix}-vm"
  admin_username                  = var.userName
  disable_password_authentication = false
  admin_password                  = var.userPassword
  user_data                       = base64encode(file("${path.module}/nginx.sh"))
  resource_group_name             = var.azure-rg-name
  location                        = var.location
  network_interface_ids           = [azurerm_network_interface.public.id, azurerm_network_interface.internal.id]
  size                            = var.vmSize
  # os_disk {
  #   caching              = "ReadWrite"
  #   storage_account_type = "Standard_LRS"
  # }
  os_disk {
    caching = var.osDisk.caching
    storage_account_type = var.osDisk.storage_account_type
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}