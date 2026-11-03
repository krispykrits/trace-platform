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
variable "aks_oidc_issuer" { type = string }
variable "foundry_resource_id" { type = string }

resource "azurerm_user_assigned_identity" "worker" {
  name                = "id-trace-worker-dev-wus3"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_federated_identity_credential" "worker" {
  name                      = "trace-worker"
  user_assigned_identity_id = azurerm_user_assigned_identity.worker.id
  audience                  = ["api://AzureADTokenExchange"]
  issuer                    = var.aks_oidc_issuer
  subject                   = "system:serviceaccount:trace:trace-worker"
}

resource "azurerm_user_assigned_identity" "api" {
  name                = "id-trace-api-dev-wus3"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_federated_identity_credential" "api" {
  name                      = "trace-api"
  user_assigned_identity_id = azurerm_user_assigned_identity.api.id
  audience                  = ["api://AzureADTokenExchange"]
  issuer                    = var.aks_oidc_issuer
  subject                   = "system:serviceaccount:trace:trace-api"
}

resource "azurerm_role_assignment" "foundry_inference" {
  scope                = var.foundry_resource_id
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = azurerm_user_assigned_identity.worker.principal_id
}

output "worker_client_id" {
  value = azurerm_user_assigned_identity.worker.client_id
}

output "api_client_id" {
  value = azurerm_user_assigned_identity.api.client_id
}
