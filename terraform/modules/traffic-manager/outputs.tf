output "traffic_manager_profile_fqdn" {
  description = "FQDN of the Traffic Manager profile"
  value       = azurerm_traffic_manager_profile.main.fqdn
}

output "traffic_manager_profile_id" {
  description = "ID of the Traffic Manager profile"
  value       = azurerm_traffic_manager_profile.main.id
}

output "traffic_manager_profile_name" {
  description = "Name of the Traffic Manager profile"
  value       = azurerm_traffic_manager_profile.main.name
}

output "endpoint_ids" {
  description = "IDs of the Traffic Manager endpoints"
  value       = azurerm_traffic_manager_azure_endpoint.endpoints[*].id
}