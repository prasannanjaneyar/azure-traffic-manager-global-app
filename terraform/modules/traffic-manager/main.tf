terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

# Traffic Manager Profile
resource "azurerm_traffic_manager_profile" "main" {
  name                   = var.traffic_manager_name
  resource_group_name    = var.resource_group_name
  traffic_routing_method = var.routing_method

  dns_config {
    relative_name = var.dns_name
    ttl           = var.dns_ttl
  }

  monitor_config {
    protocol                     = var.monitor_protocol
    port                         = var.monitor_port
    path                         = var.monitor_path
    interval_in_seconds          = var.monitor_interval
    timeout_in_seconds           = var.monitor_timeout
    tolerated_number_of_failures = var.monitor_tolerated_failures
  }

  tags = var.tags
}

# Traffic Manager Endpoints
resource "azurerm_traffic_manager_azure_endpoint" "endpoints" {
  count              = length(var.endpoints)
  name               = var.endpoints[count.index].name
  profile_id         = azurerm_traffic_manager_profile.main.id
  weight             = var.endpoints[count.index].weight
  priority           = var.endpoints[count.index].priority
  target_resource_id = var.endpoints[count.index].target_resource_id

  custom_header {
    name  = "host"
    value = var.endpoints[count.index].custom_header_host
  }

  geo_mappings = var.endpoints[count.index].geo_mappings

  endpoint_monitor_settings {
    protocol                     = var.monitor_protocol
    port                         = var.monitor_port
    path                         = var.monitor_path
    interval_in_seconds          = var.monitor_interval
    timeout_in_seconds           = var.monitor_timeout
    tolerated_number_of_failures = var.monitor_tolerated_failures
  }
}

# External Endpoints (for non-Azure resources)
resource "azurerm_traffic_manager_external_endpoint" "external_endpoints" {
  count        = length(var.external_endpoints)
  name         = var.external_endpoints[count.index].name
  profile_id   = azurerm_traffic_manager_profile.main.id
  target       = var.external_endpoints[count.index].target
  weight       = var.external_endpoints[count.index].weight
  priority     = var.external_endpoints[count.index].priority
  geo_mappings = var.external_endpoints[count.index].geo_mappings
}

# Traffic Manager Nested Endpoints (for failover scenarios)
resource "azurerm_traffic_manager_nested_endpoint" "nested_endpoints" {
  count                   = length(var.nested_endpoints)
  name                    = var.nested_endpoints[count.index].name
  profile_id              = azurerm_traffic_manager_profile.main.id
  target_resource_id      = var.nested_endpoints[count.index].target_resource_id
  weight                  = var.nested_endpoints[count.index].weight
  priority                = var.nested_endpoints[count.index].priority
  minimum_child_endpoints = var.nested_endpoints[count.index].minimum_child_endpoints
  geo_mappings            = var.nested_endpoints[count.index].geo_mappings
}