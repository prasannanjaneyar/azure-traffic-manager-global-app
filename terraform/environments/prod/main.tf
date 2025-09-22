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
    key                  = "prod/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Data sources for existing resources (if any)
data "azurerm_client_config" "current" {}

# Primary Region - East US
module "networking_primary" {
  source = "../../modules/networking"

  resource_group_name = "${var.prefix}-primary-rg"
  location            = var.primary_location
  prefix              = "${var.prefix}-primary"

  vnet_address_space                = ["10.1.0.0/16"]
  app_subnet_address_prefix         = ["10.1.1.0/24"]
  app_gateway_subnet_address_prefix = ["10.1.2.0/24"]
  enable_app_gateway                = var.enable_app_gateway

  tags = local.common_tags
}

module "app_service_primary" {
  source = "../../modules/app-service"

  prefix              = "${var.prefix}-primary"
  resource_group_name = module.networking_primary.resource_group_name
  location            = module.networking_primary.resource_group_location
  subnet_id           = module.networking_primary.app_subnet_id

  os_type           = var.os_type
  sku_name          = var.app_service_sku
  node_version      = var.node_version
  always_on         = true
  health_check_path = var.health_check_path

  app_settings = merge(var.app_settings, {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = module.app_service_primary.application_insights_instrumentation_key
    "REGION"                         = var.primary_location
    "ENVIRONMENT"                    = "production"
  })

  custom_domain = var.custom_domain

  tags = local.common_tags
}

# Secondary Region - West Europe
module "networking_secondary" {
  source = "../../modules/networking"

  resource_group_name = "${var.prefix}-secondary-rg"
  location            = var.secondary_location
  prefix              = "${var.prefix}-secondary"

  vnet_address_space                = ["10.2.0.0/16"]
  app_subnet_address_prefix         = ["10.2.1.0/24"]
  app_gateway_subnet_address_prefix = ["10.2.2.0/24"]
  enable_app_gateway                = var.enable_app_gateway

  tags = local.common_tags
}

module "app_service_secondary" {
  source = "../../modules/app-service"

  prefix              = "${var.prefix}-secondary"
  resource_group_name = module.networking_secondary.resource_group_name
  location            = module.networking_secondary.resource_group_location
  subnet_id           = module.networking_secondary.app_subnet_id

  os_type           = var.os_type
  sku_name          = var.app_service_sku
  node_version      = var.node_version
  always_on         = true
  health_check_path = var.health_check_path

  app_settings = merge(var.app_settings, {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = module.app_service_secondary.application_insights_instrumentation_key
    "REGION"                         = var.secondary_location
    "ENVIRONMENT"                    = "production"
  })

  tags = local.common_tags
}

# Traffic Manager for Global Load Balancing
module "traffic_manager" {
  source = "../../modules/traffic-manager"

  traffic_manager_name = "${var.prefix}-tm"
  resource_group_name  = module.networking_primary.resource_group_name
  dns_name             = var.traffic_manager_dns_name
  routing_method       = var.routing_method

  dns_ttl                    = 60
  monitor_protocol           = "HTTPS"
  monitor_port               = 443
  monitor_path               = var.health_check_path
  monitor_interval           = 30
  monitor_timeout            = 10
  monitor_tolerated_failures = 3

  endpoints = [
    {
      name               = "primary-endpoint"
      target_resource_id = module.app_service_primary.app_service_id
      weight             = 100
      priority           = 1
      custom_header_host = module.app_service_primary.app_service_hostname
      geo_mappings       = var.primary_geo_mappings
    },
    {
      name               = "secondary-endpoint"
      target_resource_id = module.app_service_secondary.app_service_id
      weight             = 100
      priority           = 2
      custom_header_host = module.app_service_secondary.app_service_hostname
      geo_mappings       = var.secondary_geo_mappings
    }
  ]

  tags = local.common_tags
}

# Local values
locals {
  common_tags = merge(var.tags, {
    Environment = "production"
    ManagedBy   = "Terraform"
    Project     = var.project_name
  })
}