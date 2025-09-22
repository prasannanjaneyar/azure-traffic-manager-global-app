variable "prefix" {
  description = "Prefix for all resources"
  type        = string
  default     = "myapp-prod"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "GlobalApp"
}

variable "primary_location" {
  description = "Primary Azure region"
  type        = string
  default     = "East US"
}

variable "secondary_location" {
  description = "Secondary Azure region"
  type        = string
  default     = "West Europe"
}

variable "os_type" {
  description = "Operating system type for App Service"
  type        = string
  default     = "Linux"
}

variable "app_service_sku" {
  description = "SKU for App Service Plan"
  type        = string
  default     = "P1v3"
}

variable "node_version" {
  description = "Node.js version"
  type        = string
  default     = "18-lts"
}

variable "health_check_path" {
  description = "Health check endpoint path"
  type        = string
  default     = "/health"
}

variable "custom_domain" {
  description = "Custom domain for the application"
  type        = string
  default     = null
}

variable "traffic_manager_dns_name" {
  description = "DNS name for Traffic Manager"
  type        = string
}

variable "routing_method" {
  description = "Traffic Manager routing method"
  type        = string
  default     = "Performance"
}

variable "enable_app_gateway" {
  description = "Enable Application Gateway"
  type        = bool
  default     = false
}

variable "primary_geo_mappings" {
  description = "Geographic mappings for primary endpoint"
  type        = list(string)
  default     = ["US", "CA", "MX"]
}

variable "secondary_geo_mappings" {
  description = "Geographic mappings for secondary endpoint"
  type        = list(string)
  default     = ["EU", "GB", "DE", "FR"]
}

variable "app_settings" {
  description = "Application settings"
  type        = map(string)
  default     = {
    "NODE_ENV"     = "production"
    "PORT"         = "80"
    "WEBSITE_NODE_DEFAULT_VERSION" = "18.17.1"
  }
}

variable "tags" {
  description = "Default tags for resources"
  type        = map(string)
  default = {
    Owner       = "DevOps Team"
    CostCenter  = "Engineering"
    Environment = "Production"
  }
}