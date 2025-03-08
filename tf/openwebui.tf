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

resource "azurerm_log_analytics_workspace" "openwebui" {
  name                = "log-openwebui"
  location            = azurerm_resource_group.openwebui.location
  resource_group_name = azurerm_resource_group.openwebui.name
  sku                 = "PerGB2018"
  retention_in_days   = 3
}

resource "azurerm_container_app_environment" "openwebui" {
  name                       = "cae-openwebui"
  location                   = azurerm_resource_group.openwebui.location
  resource_group_name        = azurerm_resource_group.openwebui.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.openwebui.id
}

resource "azurerm_container_app" "openwebui" {
  name                         = "ca-openwebui"
  container_app_environment_id = azurerm_container_app_environment.openwebui.id
  resource_group_name          = azurerm_resource_group.openwebui.name
  revision_mode                = "Single"

  template {
    container {
      name   = "openwebui"
      image  = local.container_image
      cpu    = local.container_cpu
      memory = local.container_memory
    }
  }

}
