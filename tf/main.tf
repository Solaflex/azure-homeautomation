# Create a resource group
resource "azurerm_resource_group" "test" {
  name     = "rg-openwebui"
  location = local.location
}