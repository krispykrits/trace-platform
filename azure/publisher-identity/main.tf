terraform {
  required_version = ">= 1.17.0, < 2.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 5.12.0"
    }
  }
  backend "azurerm" {
    use_azuread_auth = true
    use_cli          = true
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
}

variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "registry_id" { type = string }

resource "azurerm_user_assigned_identity" "publisher" {
  name                = "id-trace-publisher-dev-ncus"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_federated_identity_credential" "github" {
  name                      = "trace-build-development"
  user_assigned_identity_id = azurerm_user_assigned_identity.publisher.id
  audience                  = ["api://AzureADTokenExchange"]
  issuer                    = "https://token.actions.githubusercontent.com"
  subject                   = "repo:krispykrits/TRACE:ref:refs/heads/main"
}

resource "azurerm_role_assignment" "acr_push" {
  scope                = var.registry_id
  role_definition_name = "AcrPush"
  principal_id         = azurerm_user_assigned_identity.publisher.principal_id
}

resource "azurerm_role_assignment" "registry_reader" {
  scope                = var.registry_id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.publisher.principal_id
}

output "publisher_client_id" {
  value = azurerm_user_assigned_identity.publisher.client_id
}
