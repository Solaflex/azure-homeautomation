terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }    
  }

  backend "azurerm" {
        resource_group_name  = "rg-terraform"
        storage_account_name = "stterraformwaechter365"
        container_name       = "tfstate"
        key                  = "terraform.tfstate"
    }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}