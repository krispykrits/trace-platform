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
variable "aks_resource_id" { type = string }

resource "azurerm_user_assigned_identity" "deployer" {
  name                = "id-trace-deployer-dev-wus3"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_federated_identity_credential" "github" {
  name                      = "trace-platform-development"
  user_assigned_identity_id = azurerm_user_assigned_identity.deployer.id
  audience                  = ["api://AzureADTokenExchange"]
  issuer                    = "https://token.actions.githubusercontent.com"
  subject                   = "repo:krispykrits@64175002/trace-platform@1441483907:environment:development"
}

resource "azurerm_role_assignment" "cluster_user" {
  scope                = var.aks_resource_id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = azurerm_user_assigned_identity.deployer.principal_id
}

resource "azurerm_role_assignment" "namespace_writer" {
  scope                = "${var.aks_resource_id}/namespaces/trace"
  role_definition_name = "Azure Kubernetes Service RBAC Writer"
  principal_id         = azurerm_user_assigned_identity.deployer.principal_id
}

output "deployer_client_id" {
  value = azurerm_user_assigned_identity.deployer.client_id
}
