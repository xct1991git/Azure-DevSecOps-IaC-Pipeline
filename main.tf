terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group de producción
resource "azurerm_resource_group" "sec_rg" {
  name     = "rg-secure-storage-prod"
  location = "northeurope"

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform-DevSecOps"
  }
}

# Storage Account con configuraciones de seguridad auditables
resource "azurerm_storage_account" "sec_storage" {
  name                     = "stsecopsdemoprod001"
  resource_group_name      = azurerm_resource_group.sec_rg.name
  location                 = azurerm_resource_group.sec_rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  # Controles de seguridad requeridos por estándares CIS / ISO 27001
  enable_https_traffic_only       = true
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false

  tags = {
    Compliance = "CIS-Benchmark"
    ManagedBy  = "Terraform"
  }
}
