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

variable "aks_id" { type = string }
variable "postgres_id" { type = string }
variable "foundry_id" { type = string }
variable "log_analytics_id" { type = string }

import {
  to = azurerm_kubernetes_cluster.trace
  id = var.aks_id
}

import {
  to = azurerm_postgresql_flexible_server.trace
  id = var.postgres_id
}

import {
  to = azurerm_cognitive_account.foundry
  id = var.foundry_id
}

import {
  to = azurerm_log_analytics_workspace.trace
  id = var.log_analytics_id
}
