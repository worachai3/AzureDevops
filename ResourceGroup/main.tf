terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.96.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  tags = {
    environment = "Lab"
    owner = "Worachai"
  }
}

resource "azurerm_resource_group" "resourcegroup" {
  name     = var.rsgname
  location = var.location

  tags = local.tags
}

resource "azurerm_storage_account" "name" {
  name =  var.stgactname
  resource_group_name = azurerm_resource_group.resourcegroup.name
  location = azurerm_resource_group.resourcegroup.location
  account_tier = "Standard"
  account_replication_type = "GRS"

  tags = local.tags
}