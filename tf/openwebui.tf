# Create a resource group
resource "azurerm_resource_group" "openwebui" {
  name     = "rg-openwebui"
  location = local.location
}

resource "azurerm_storage_account" "openwebui" {
  name                     = "stopenwebuiwaechter365"
  resource_group_name      = azurerm_resource_group.openwebui.name
  location                 = azurerm_resource_group.openwebui.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "aistorage" {
  name                 = "ai-storage-file-share"
  storage_account_id = azurerm_storage_account.openwebui.id
  access_tier = "TransactionOptimized"
  quota                = 50
}
