variable "prefix" {
  description = "Prefix for all global resources"
  type        = string
  default     = "globalapp"
}

variable "location" {
  description = "Primary location for shared resources"
  type        = string
  default     = "East US"
}

variable "environment" {
  description = "Environment name (global shared resources)"
  type        = string
  default     = "shared"
}

variable "log_analytics_retention_days" {
  description = "Number of days to retain logs in Log Analytics workspace"
  type        = number
  default     = 90
}

variable "key_vault_sku" {
  description = "SKU for Key Vault"
  type        = string
  default     = "standard"
  validation {
    condition     = contains(["standard", "premium"], var.key_vault_sku)
    error_message = "Key Vault SKU must be either 'standard' or 'premium'."
  }
}

variable "key_vault_purge_protection" {
  description = "Enable purge protection for Key Vault"
  type        = bool
  default     = false
}

variable "application_insights_sampling_percentage" {
  description = "Sampling percentage for Application Insights"
  type        = number
  default     = 100
  validation {
    condition     = var.application_insights_sampling_percentage >= 0 && var.application_insights_sampling_percentage <= 100
    error_message = "Sampling percentage must be between 0 and 100."
  }
}

variable "cost_center" {
  description = "Cost center for billing purposes"
  type        = string
  default     = "Engineering"
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "DevOps Team"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "Shared"
    ManagedBy   = "Terraform"
    Component   = "Global"
  }
}