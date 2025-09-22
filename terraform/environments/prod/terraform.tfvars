# Project Configuration
prefix       = "globalapp-prod"
project_name = "GlobalApplication"

# Geographic Configuration
primary_location   = "East US"
secondary_location = "West Europe"

# Application Configuration
os_type           = "Linux"
app_service_sku   = "P1v3"
node_version      = "18-lts"
health_check_path = "/api/health"

# Traffic Manager Configuration
traffic_manager_dns_name = "globalapp-prod"
routing_method           = "Performance"

# Geographic Routing Configuration
primary_geo_mappings   = ["US", "CA", "MX"]
secondary_geo_mappings = ["EU", "GB", "DE", "FR", "IT", "ES"]

# Application Settings
app_settings = {
  "NODE_ENV"                                   = "production"
  "PORT"                                       = "80"
  "WEBSITE_NODE_DEFAULT_VERSION"               = "18.17.1"
  "WEBSITE_RUN_FROM_PACKAGE"                   = "1"
  "APPINSIGHTS_PROFILERFEATURE_VERSION"        = "1.0.0"
  "APPINSIGHTS_SNAPSHOTFEATURE_VERSION"        = "1.0.0"
  "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"
  "XDT_MicrosoftApplicationInsights_Mode"      = "Recommended"
}

# Feature Flags
enable_app_gateway = false

# Tags
tags = {
  Environment = "Production"
  Owner       = "DevOps Team"
  CostCenter  = "Engineering"
  Project     = "GlobalApplication"
  Backup      = "Required"
  Monitoring  = "Enabled"
}