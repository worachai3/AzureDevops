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

resource "azurerm_resource_group" "resource_group_name" {
  name =  var.rsgname
  location = var.location
}