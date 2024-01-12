terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.86.0"
    }
  }
}
provider "azurerm" {
  features {}
}

module "azure-network" {
  source                    = "./azure-network"
  prefix                    = var.prefix
  location                  = var.location
  vnet_address_space        = var.vnet_address_space
  internal_address_prefixes = var.internal_address_prefixes
  public_address_prefixes   = var.public_address_prefixes
}

module "azure-nginx-server" {
  source          = "./azure-nginx-server"
  prefix          = var.prefix
  azure-rg-name   = module.azure-network.resource_group_name
  location        = module.azure-network.resource_group_location
  internal_subnet = module.azure-network.azure-internal-subnet
  public_subnet   = module.azure-network.azure-public-subnet
  userName        = var.userName
  userPassword    = var.userPassword
  vmSize          = var.vmSize
  osDisk          = var.osDisk
}

module "azure-security-groups" {
  source               = "./azure-security-groups"
  prefix               = var.prefix
  azure-rg-name        = module.azure-network.resource_group_name
  location             = module.azure-network.resource_group_location
  public-interface-id  = module.azure-nginx-server.public-interface-id
  private-interface-id = module.azure-nginx-server.private-interface-id
  private_vm_addresses = module.azure-nginx-server.private_vm_addresses
}

module "azure-load-balancer" {
  source                = "./azure-load-balancer"
  prefix                = var.prefix
  azure-rg-name         = module.azure-network.resource_group_name
  location              = module.azure-network.resource_group_location
  private-interface-id  = module.azure-nginx-server.private-interface-id
  ip_configuration_name = module.azure-nginx-server.ip_configuration_name

}