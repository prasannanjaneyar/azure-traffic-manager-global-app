# Global resources that are shared across environments
terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
  
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstateaccount09876"
    container_name       = "tfstate"
    key                  = "global/terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

# Data source for current client configuration
data "azurerm_client_config" "current" {}

# Shared Resource Group
resource "azurerm_resource_group" "shared" {
  name     = "${var.prefix}-shared-rg"
  location = var.location

  tags = merge(var.tags, {
    Component   = "SharedInfrastructure"
    CostCenter  = var.cost_center
    Owner       = var.owner
    Environment = var.environment
  })
}

# Shared Key Vault for secrets
resource "azurerm_key_vault" "shared" {
  name                        = "${var.prefix}-shared-kv"
  location                    = azurerm_resource_group.shared.location
  resource_group_name         = azurerm_resource_group.shared.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = var.key_vault_purge_protection
  sku_name                   = var.key_vault_sku

  # Default access policy for the current user/service principal
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Get",
      "List",
      "Update",
      "Delete",
      "Purge",
      "Recover",
      "Import",
      "Backup",
      "Restore"
    ]

    secret_permissions = [
      "Set",
      "Get",
      "List",
      "Delete",
      "Purge",
      "Recover",
      "Backup",
      "Restore"
    ]

    certificate_permissions = [
      "Create",
      "Get",
      "List",
      "Update",
      "Delete",
      "Purge",
      "Recover",
      "Import",
      "Backup",
      "Restore",
      "ManageContacts",
      "ManageIssuers"
    ]
  }

  tags = merge(var.tags, {
    Component  = "Security"
    CostCenter = var.cost_center
    Owner      = var.owner
  })
}

# Central Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "central" {
  name                = "${var.prefix}-central-law"
  location            = azurerm_resource_group.shared.location
  resource_group_name = azurerm_resource_group.shared.name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_analytics_retention_days

  tags = merge(var.tags, {
    Component  = "Monitoring"
    CostCenter = var.cost_center
    Owner      = var.owner
  })
}

# Central Application Insights for global monitoring
resource "azurerm_application_insights" "central" {
  name                = "${var.prefix}-central-ai"
  location            = azurerm_resource_group.shared.location
  resource_group_name = azurerm_resource_group.shared.name
  workspace_id        = azurerm_log_analytics_workspace.central.id
  application_type    = "web"
  sampling_percentage = var.application_insights_sampling_percentage

  tags = merge(var.tags, {
    Component  = "Monitoring"
    CostCenter = var.cost_center
    Owner      = var.owner
  })
}

# Store Application Insights key in Key Vault
resource "azurerm_key_vault_secret" "app_insights_key" {
  name         = "appinsights-instrumentation-key"
  value        = azurerm_application_insights.central.instrumentation_key
  key_vault_id = azurerm_key_vault.shared.id

  depends_on = [azurerm_key_vault.shared]

  tags = {
    Component = "Monitoring"
    Purpose   = "ApplicationInsights"
  }
}

# Store Application Insights connection string in Key Vault
resource "azurerm_key_vault_secret" "app_insights_connection_string" {
  name         = "appinsights-connection-string"
  value        = azurerm_application_insights.central.connection_string
  key_vault_id = azurerm_key_vault.shared.id

  depends_on = [azurerm_key_vault.shared]

  tags = {
    Component = "Monitoring"
    Purpose   = "ApplicationInsights"
  }
}