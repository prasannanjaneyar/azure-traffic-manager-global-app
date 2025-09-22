variable "prefix" {
  type        = string
  description = "Prefix for resources"
}

variable "resource_group_name" {
  type        = string
  description = "Target Resource Group"
}

variable "location" {
  type        = string
  default     = "EastUS"
}

variable "os_type" {
  type        = string
  default     = "Linux"
  validation {
    condition     = var.os_type == "Linux" || var.os_type == "Windows"
    error_message = "os_type must be either 'Linux' or 'Windows'"
  }
}

variable "sku_name" {
  type        = string
  default     = "P1v3" # PremiumV3
  validation {
    condition     = contains(["B1", "B2", "S1", "S2", "P1v3", "P2v3", "P3v3"], var.sku_name)
    error_message = "SKU must be one of: B1, B2, S1, S2, P1v3, P2v3, P3v3"
  }
}

variable "node_version" {
  type        = string
  default     = "18-lts"
}

variable "always_on" {
  type        = bool
  default     = true
}

variable "health_check_path" {
  type        = string
  default     = "/healthz"
}

variable "app_settings" {
  type        = map(string)
  default     = {}
}

variable "subnet_id" {
  type        = string
  default     = ""
}

variable "tags" {
  type        = map(string)
  default     = {}
}

variable "custom_domain" {
  type        = string
  default     = null
}
