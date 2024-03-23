terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.96.0"
    }
  }
  backend "azurerm" {
    resource_group_name = "tfstateRG01"
    storage_account_name = "tfstate01670954844"
    container_name = "tfstate"
    key = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "vnet_rg" {
  name = var.resourcegroup_name
  location = var.location
  tags = var.tags
}

resource "azurerm_virtual_network" "vnet" {
  name = var.vnet_name
  address_space = var.vnet_address_space
  location = var.location
  resource_group_name = var.resourcegroup_name
  tags = var.tags

  depends_on = [ azurerm_resource_group.vnet_rg ]
}

resource "azurerm_subnet" "subnet" {
  for_each = var.subnets
  resource_group_name = var.resourcegroup_name
  virtual_network_name = var.vnet_name
  name = each.value["name"]
  address_prefixes = each.value["address_prefixes"]

  depends_on = [ azurerm_resource_group.vnet_rg, azurerm_virtual_network.vnet ]
}

# Bastion Host doesn't need public ip this is for example only
resource "azurerm_public_ip" "bastion_pubip" {
  name = "${var.bastionhost_name}PubIP"
  location = var.location
  resource_group_name = var.resourcegroup_name
  allocation_method = "Static"
  sku = "Standard"
  tags = var.tags

  depends_on = [ azurerm_resource_group.vnet_rg ]
}

resource "azurerm_bastion_host" "bastion" {
  name = var.bastionhost_name
  location = var.location
  resource_group_name = var.resourcegroup_name
  tags = var.tags

  ip_configuration {
    name = "bastion_config"
    subnet_id = azurerm_subnet.subnet["bastion_subnet"].id
    public_ip_address_id = azurerm_public_ip.bastion_pubip.id
  }

  depends_on = [ azurerm_resource_group.vnet_rg, azurerm_public_ip.bastion_pubip ]
}
