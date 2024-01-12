resource "azurerm_public_ip" "lb_public_ip" {
  name                = "${var.prefix}PublicIPForLB"
  resource_group_name = var.azure-rg-name
  location            = var.location
  allocation_method   = "Static" 
}

resource "azurerm_lb" "nginx_lb" {
  name                = "${var.prefix}-LoadBalancer"
  resource_group_name = var.azure-rg-name
  location            = var.location

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  loadbalancer_id     = azurerm_lb.nginx_lb.id
  name                = "${var.prefix}-BackEndAddressPool"
}
resource "azurerm_network_interface_backend_address_pool_association" "nic_bckend_association" {
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
  ip_configuration_name   = var.ip_configuration_name
  network_interface_id    = var.private-interface-id
}

resource "azurerm_lb_rule" "lb_rules" {
  loadbalancer_id                = azurerm_lb.nginx_lb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.nginx_lb.frontend_ip_configuration[0].name
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.backend_pool.id]
}
