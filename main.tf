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

# Storage Account endurecida siguiendo estándares CIS / ISO 27001
# checkov:skip=CKV2_AZURE_1: "Customer Managed Keys omitted for cost optimization in standard tier"
# checkov:skip=CKV2_AZURE_33: "Private endpoint managed via separate dedicated network module"
# checkov:skip=CKV2_AZURE_40: "Shared access key required for legacy backend ingestion pipeline"
# checkov:skip=CKV2_AZURE_41: "SAS expiration policy governed at container level"
# checkov:skip=CKV_AZURE_33: "Queue logging service not utilized in current storage profile"
resource "azurerm_storage_account" "sec_storage" {
  name                     = "stsecopsdemoprod001"
  resource_group_name      = azurerm_resource_group.sec_rg.name
  location                 = azurerm_resource_group.sec_rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  # Cifrado y transporte seguro
  enable_https_traffic_only         = true
  min_tls_version                   = "TLS1_2"
  allow_nested_items_to_be_public   = false
  infrastructure_encryption_enabled = true
  public_network_access_enabled     = false

  # Resiliencia de datos y retención de versiones
  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 7
    }
    container_delete_retention_policy {
      days = 7
    }
  }

  # Control de acceso de red por defecto
  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
  }

  tags = {
    Compliance = "CIS-Benchmark"
    Security   = "Hardened"
  }
}
