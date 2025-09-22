# Traffic Manager Outputs
output "traffic_manager_fqdn" {
  description = "Fully qualified domain name of the Traffic Manager profile"
  value       = module.traffic_manager.traffic_manager_profile_fqdn
}

output "traffic_manager_profile_id" {
  description = "ID of the Traffic Manager profile"
  value       = module.traffic_manager.traffic_manager_profile_id
}

# Primary Region Outputs
output "primary_resource_group_name" {
  description = "Name of the primary region resource group"
  value       = module.networking_primary.resource_group_name
}

output "primary_app_service_name" {
  description = "Name of the primary App Service"
  value       = module.app_service_primary.app_service_name
}

output "primary_app_service_url" {
  description = "URL of the primary App Service"
  value       = "https://${module.app_service_primary.app_service_hostname}"
}

output "primary_app_service_hostname" {
  description = "Hostname of the primary App Service"
  value       = module.app_service_primary.app_service_hostname
}

output "primary_application_insights_key" {
  description = "Application Insights instrumentation key for primary region"
  value       = module.app_service_primary.application_insights_instrumentation_key
  sensitive   = true
}

# Secondary Region Outputs
output "secondary_resource_group_name" {
  description = "Name of the secondary region resource group"
  value       = module.networking_secondary.resource_group_name
}

output "secondary_app_service_name" {
  description = "Name of the secondary App Service"
  value       = module.app_service_secondary.app_service_name
}

output "secondary_app_service_url" {
  description = "URL of the secondary App Service"
  value       = "https://${module.app_service_secondary.app_service_hostname}"
}

output "secondary_app_service_hostname" {
  description = "Hostname of the secondary App Service"
  value       = module.app_service_secondary.app_service_hostname
}

output "secondary_application_insights_key" {
  description = "Application Insights instrumentation key for secondary region"
  value       = module.app_service_secondary.application_insights_instrumentation_key
  sensitive   = true
}

# Network Outputs
output "primary_vnet_id" {
  description = "ID of the primary virtual network"
  value       = module.networking_primary.vnet_id
}

output "secondary_vnet_id" {
  description = "ID of the secondary virtual network"
  value       = module.networking_secondary.vnet_id
}

# Health Check URLs
output "health_check_urls" {
  description = "Health check URLs for both regions"
  value = {
    primary   = "https://${module.app_service_primary.app_service_hostname}${var.health_check_path}"
    secondary = "https://${module.app_service_secondary.app_service_hostname}${var.health_check_path}"
    global    = "https://${module.traffic_manager.traffic_manager_profile_fqdn}${var.health_check_path}"
  }
}

# Application URLs
output "application_urls" {
  description = "Application URLs"
  value = {
    global_url    = "https://${module.traffic_manager.traffic_manager_profile_fqdn}"
    primary_url   = "https://${module.app_service_primary.app_service_hostname}"
    secondary_url = "https://${module.app_service_secondary.app_service_hostname}"
  }
}

# Resource Summary
output "deployment_summary" {
  description = "Summary of deployed resources"
  value = {
    environment          = "production"
    traffic_manager_fqdn = module.traffic_manager.traffic_manager_profile_fqdn
    primary_region       = var.primary_location
    secondary_region     = var.secondary_location
    routing_method       = var.routing_method
    deployment_time      = timestamp()
  }
}

# Monitoring Outputs
output "monitoring_dashboard_url" {
  description = "URL to Azure Portal monitoring dashboard"
  value       = "https://portal.azure.com/#@${data.azurerm_client_config.current.tenant_id}/dashboard/private/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${module.networking_primary.resource_group_name}/providers/Microsoft.Portal/dashboards"
}

# Data source for current configuration
data "azurerm_client_config" "current" {}