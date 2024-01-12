variable "prefix" {}
variable "azure-rg-name" {}
variable "location" {}
variable "public-interface-id" {}
variable "private-interface-id" {}
variable "private_vm_addresses" {
    description = "Accepts list of private VM addresses, the first is used for ssh access the second for http requests "
}