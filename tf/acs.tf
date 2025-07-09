# Create an application
resource "azuread_application_registration" "smtp" {
  display_name = "smtp"
}

# Create a service principal
resource "azuread_service_principal" "smtp" {
  client_id = azuread_application_registration.smtp.client_id
}

resource "azuread_service_principal_password" "smtp" {
  service_principal_id = azuread_service_principal.smtp.id
  end_date             = "2099-01-01T01:02:03Z"
}

output "smtp_client_secret" {
  value     = azuread_service_principal_password.smtp.value
  sensitive = true
}
# terraform output smtp_client_secret


resource "azurerm_resource_group" "acs" {
  name     = "rg-azurecommunicationservice"
  location = "West Europe"
}

resource "azurerm_communication_service" "main" {
  name                = "acs-main-waechter365"
  resource_group_name = azurerm_resource_group.acs.name
  data_location       = "Europe"
}

resource "azurerm_email_communication_service" "main" {
  name                = "acs-email-main"
  resource_group_name = azurerm_resource_group.acs.name
  data_location       = "Europe"
}

resource "azurerm_email_communication_service_domain" "zzl" {
  name              = "zwischen-zwei-laendern.com"
  email_service_id  = azurerm_email_communication_service.main.id
  domain_management = "CustomerManaged"
}

resource "azurerm_email_communication_service_domain_sender_username" "noreply" {
  name                    = "noreply"
  email_service_domain_id = azurerm_email_communication_service_domain.zzl.id
}

# resource "azurerm_communication_service_email_domain_association" "smtp" {
#   communication_service_id = azurerm_communication_service.main.id
#   email_service_domain_id  = azurerm_email_communication_service_domain.zzl.id
# }


resource "azurerm_role_assignment" "smtp" {
  scope                = azurerm_communication_service.main.id
  role_definition_name = "Communication and Email Service Owner"
  principal_id         = azuread_service_principal.smtp.object_id
}
