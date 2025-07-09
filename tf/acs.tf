resource "azurerm_resource_group" "acs" {
  name     = "rg-azurecommunicationservice"
  location = "West Europe"
}

resource "azurerm_email_communication_service" "main" {
  name                = "acs-main"
  resource_group_name = azurerm_resource_group.acs.name
  data_location       = "Europe"
}

resource "azurerm_email_communication_service_domain" "zzl" {
  name              = "zwischen-zwei-laendern.com"
  email_service_id  = azurerm_email_communication_service.main.id
  domain_management = "CustomerManaged"
}

resource "azurerm_email_communication_service_domain_sender_username" "noreply" {
  name                    = "noreply-su"
  email_service_domain_id = azurerm_email_communication_service_domain.zzl.id
}
