variable "traffic_manager_name" {
  description = "Name of the Traffic Manager profile"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "dns_name" {
  description = "Relative DNS name for the Traffic Manager profile"
  type        = string
}

variable "routing_method" {
  description = "Traffic routing method"
  type        = string
  default     = "Performance"
  validation {
    condition     = contains(["Performance", "Weighted", "Priority", "Geographic", "MultiValue", "Subnet"], var.routing_method)
    error_message = "Routing method must be one of: Performance, Weighted, Priority, Geographic, MultiValue, Subnet."
  }
}

variable "dns_ttl" {
  description = "DNS TTL in seconds"
  type        = number
  default     = 60
}

variable "monitor_protocol" {
  description = "Protocol for health monitoring"
  type        = string
  default     = "HTTPS"
  validation {
    condition     = contains(["HTTP", "HTTPS", "TCP"], var.monitor_protocol)
    error_message = "Monitor protocol must be HTTP, HTTPS, or TCP."
  }
}

variable "monitor_port" {
  description = "Port for health monitoring"
  type        = number
  default     = 443
}

variable "monitor_path" {
  description = "Path for health monitoring"
  type        = string
  default     = "/health"
}

variable "monitor_interval" {
  description = "Health check interval in seconds"
  type        = number
  default     = 30
}

variable "monitor_timeout" {
  description = "Health check timeout in seconds"
  type        = number
  default     = 10
}

variable "monitor_tolerated_failures" {
  description = "Number of tolerated failures before marking endpoint as degraded"
  type        = number
  default     = 3
}

variable "endpoints" {
  description = "List of Azure endpoints"
  type = list(object({
    name               = string
    target_resource_id = string
    weight             = number
    priority           = number
    custom_header_host = optional(string)
    geo_mappings       = optional(list(string), [])
  }))
  default = []
}

variable "external_endpoints" {
  description = "List of external endpoints"
  type = list(object({
    name         = string
    target       = string
    weight       = number
    priority     = number
    geo_mappings = optional(list(string), [])
  }))
  default = []
}

variable "nested_endpoints" {
  description = "List of nested Traffic Manager endpoints"
  type = list(object({
    name                    = string
    target_resource_id      = string
    weight                  = number
    priority                = number
    minimum_child_endpoints = number
    geo_mappings            = optional(list(string), [])
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}