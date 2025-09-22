# Resource Group Outputs
output "shared_resource_group_name" {
  description = "Name of the shared resource group"
  value       = azurerm_resource_group.shared.name
}

output "shared_resource_group_id" {
  description = "ID of the shared resource group"
  value       = azurerm_resource_group.shared.id
}

# Key Vault Outputs
output "key_vault_name" {
  description = "Name of the shared Key Vault"
  value       = azurerm_key_vault.shared.name
}

output "key_vault_id" {
  description = "ID of the shared Key Vault"
  value       = azurerm_key_vault.shared.id
}

output "key_vault_uri" {
  description = "URI of the shared Key Vault"
  value       = azurerm_key_vault.shared.vault_uri
}

# Log Analytics Outputs
output "log_analytics_workspace_name" {
  description = "Name of the central Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.central.name
}

output "log_analytics_workspace_id" {
  description = "ID of the central Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.central.id
}

# Application Insights Outputs
output "application_insights_name" {
  description = "Name of the central Application Insights instance"
  value       = azurerm_application_insights.central.name
}

output "application_insights_instrumentation_key" {
  description = "Instrumentation key for central Application Insights"
  value       = azurerm_application_insights.central.instrumentation_key
  sensitive   = true
}

output "application_insights_connection_string" {
  description = "Connection string for central Application Insights"
  value       = azurerm_application_insights.central.connection_string
  sensitive   = true
}