# main.tf
terraform {  
  backend "azurerm"{
  }
}
provider azurerm {
  features {}
}

data "azurerm_client_config" "current" {}

# Create resource group
module "rg" {
    source = "./modules/rg"

    prefix      = var.prefix
    environment = var.environment
    location    = var.location
    tags        = var.tags
}

# Create hub virtual network
module "vnet_hub" {
  source = "./modules/vnet/hub"

  prefix              = var.prefix
  environment         = var.environment
  location            = module.rg.location
  tags                = var.tags
  resource_group_name = module.rg.name

  hub_address_space           = ["10.0.0.0/22"]
  hub_dns_servers             = ["8.8.8.8", "8.8.4.4"]
  hub_gateway_address_prefix  = "10.0.0.0/26"
  hub_firewall_address_prefix = "10.0.0.64/26"
  hub_default_address_prefix  = "10.0.1.0/24"
}

# Create spoke virtual network
module "vnet_spoke01" {
  source = "./modules/vnet/spoke01"

  prefix              = var.prefix
  environment         = var.environment
  location            = module.rg.location
  tags                = var.tags
  resource_group_name = module.rg.name

  spoke01_address_space          = ["10.1.0.0/22"]
  spoke01_dns_servers            = ["8.8.8.8", "8.8.4.4"]
  spoke01_default_address_prefix = "10.1.1.0/24"

  hub_name = module.vnet_hub.name
  hub_id   = module.vnet_hub.id
}

# Create spoke virtual network
module "vnet_spoke02" {
  source = "./modules/vnet/spoke02"

  prefix              = var.prefix
  environment         = var.environment
  location            = module.rg.location
  tags                = var.tags
  resource_group_name = module.rg.name

  spoke02_address_space          = ["10.2.0.0/22"]
  spoke02_dns_servers            = ["8.8.8.8", "8.8.4.4"]
  spoke02_default_address_prefix = "10.2.1.0/24"

  hub_name = module.vnet_hub.name
  hub_id   = module.vnet_hub.id
}