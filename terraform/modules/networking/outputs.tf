output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Location of the created resource group"
  value       = azurerm_resource_group.main.location
}

output "vnet_id" {
  description = "ID of the created virtual network"
  value       = azurerm_virtual_network.main.id
}

output "app_subnet_id" {
  description = "ID of the app service subnet"
  value       = azurerm_subnet.app_service.id
}

output "app_gateway_subnet_id" {
  description = "ID of the application gateway subnet"
  value       = var.enable_app_gateway ? azurerm_subnet.app_gateway[0].id : null
}

output "app_gateway_public_ip" {
  description = "Public IP of the application gateway"
  value       = var.enable_app_gateway ? azurerm_public_ip.app_gateway[0].ip_address : null
}