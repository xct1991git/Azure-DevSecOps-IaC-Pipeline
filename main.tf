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

resource "azurerm_resource_group" "sec_rg" {
  name     = "rg-secure-storage-prod"
  location = "northeurope"

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform-DevSecOps"
  }
}

resource "azurerm_storage_account" "sec_storage" {
  name                     = "stsecopsdemoprod001"
  resource_group_name      = azurerm_resource_group.sec_rg.name
  location                 = azurerm_resource_group.sec_rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  enable_https_traffic_only         = true
  min_tls_version                   = "TLS1_2"
  allow_nested_items_to_be_public   = false
  infrastructure_encryption_enabled = true
  public_network_access_enabled     = false

  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 7
    }
    container_delete_retention_policy {
      days = 7
    }
  }

  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
  }

  tags = {
    Compliance = "CIS-Benchmark"
    Security   = "Hardened"
  }
}
