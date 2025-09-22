terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}


resource "azurerm_service_plan" "main" {
  name                = "${var.prefix}-asp"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = var.os_type
  sku_name            = var.sku_name

  # Required for Linux
  reserved = var.os_type == "Linux" ? true : false
  kind     = var.os_type == "Linux" ? "Linux" : "App"

  tags = var.tags
}

##############################
# LINUX APP SERVICE
##############################
resource "azurerm_linux_web_app" "main" {
  count               = var.os_type == "Linux" ? 1 : 0
  name                = "${var.prefix}-app"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    always_on = var.always_on
    application_stack {
      node_version = var.node_version
    }
    health_check_path = var.health_check_path
  }

  app_settings = var.app_settings

  identity {
    type = "SystemAssigned"
  }

  dynamic "virtual_network_subnet_id" {
    for_each = var.subnet_id != "" ? [var.subnet_id] : []
    content {
      virtual_network_subnet_id = virtual_network_subnet_id.value
    }
  }

  tags = var.tags
}

##############################
# WINDOWS APP SERVICE
##############################
resource "azurerm_windows_web_app" "main" {
  count               = var.os_type == "Windows" ? 1 : 0
  name                = "${var.prefix}-app"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    always_on         = var.always_on
    health_check_path = var.health_check_path
    application_stack {
      current_stack = "node"
      node_version  = var.node_version
    }
  }

  app_settings = var.app_settings

  identity {
    type = "SystemAssigned"
  }

  dynamic "virtual_network_subnet_id" {
    for_each = var.subnet_id != "" ? [var.subnet_id] : []
    content {
      virtual_network_subnet_id = virtual_network_subnet_id.value
    }
  }

  tags = var.tags
}

##############################
# APPLICATION INSIGHTS
##############################
resource "azurerm_log_analytics_workspace" "main" {
  name                = "${var.prefix}-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = var.tags
}

resource "azurerm_application_insights" "main" {
  name                = "${var.prefix}-ai"
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_id        = azurerm_log_analytics_workspace.main.id
  application_type    = "web"

  tags = var.tags
}

##############################
# CUSTOM DOMAIN & SSL (Optional)
##############################
resource "azurerm_app_service_custom_hostname_binding" "main" {
  count               = var.custom_domain != null ? 1 : 0
  hostname            = var.custom_domain
  app_service_name    = local.app_service_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_app_service_managed_certificate" "main" {
  count                      = var.custom_domain != null ? 1 : 0
  custom_hostname_binding_id = azurerm_app_service_custom_hostname_binding.main[0].id
}

resource "azurerm_app_service_certificate_binding" "main" {
  count               = var.custom_domain != null ? 1 : 0
  hostname_binding_id = azurerm_app_service_custom_hostname_binding.main[0].id
  certificate_id      = azurerm_app_service_managed_certificate.main[0].id
  ssl_state           = "SniEnabled"
}

##############################
# LOCAL APP SERVICE NAME
##############################
locals {
  app_service_name = var.os_type == "Linux" ? azurerm_linux_web_app.main[0].name : azurerm_windows_web_app.main[0].name
}


# # App Service Plan
# resource "azurerm_service_plan" "main" {
#   name                = "${var.prefix}-asp"
#   resource_group_name = var.resource_group_name
#   location            = var.location
#   os_type             = var.os_type
#   sku_name            = var.sku_name

#   tags = var.tags
# }

# # App Service - Linux
# resource "azurerm_linux_web_app" "main" {
#   count               = var.os_type == "Linux" ? 1 : 0
#   name                = "${var.prefix}-app"
#   resource_group_name = var.resource_group_name
#   location            = var.location
#   service_plan_id     = azurerm_service_plan.main.id

#   site_config {
#     always_on = var.always_on
#     application_stack {
#       node_version = var.node_version
#     }
#     health_check_path = var.health_check_path
#     # Removed: health_check_grace_period_seconds = 300
#   }

#   app_settings = var.app_settings

#   identity {
#     type = "SystemAssigned"
#   }

#   virtual_network_subnet_id = var.subnet_id

#   tags = var.tags
# }

# # App Service - Windows  
# resource "azurerm_windows_web_app" "main" {
#   count               = var.os_type == "Windows" ? 1 : 0
#   name                = "${var.prefix}-app"
#   resource_group_name = var.resource_group_name
#   location            = var.location
#   service_plan_id     = azurerm_service_plan.main.id

#   site_config {
#     always_on         = var.always_on
#     health_check_path = var.health_check_path
#     application_stack {
#       current_stack = "node"
#       node_version  = var.node_version
#     }
#     # Removed: health_check_grace_period_seconds = 300
#   }

#   app_settings = var.app_settings

#   identity {
#     type = "SystemAssigned"
#   }

#   virtual_network_subnet_id = var.subnet_id

#   tags = var.tags
# }

# # Application Insights
# resource "azurerm_log_analytics_workspace" "main" {
#   name                = "${var.prefix}-law"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   sku                 = "PerGB2018"
#   retention_in_days   = 30

#   tags = var.tags
# }

# resource "azurerm_application_insights" "main" {
#   name                = "${var.prefix}-ai"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   workspace_id        = azurerm_log_analytics_workspace.main.id
#   application_type    = "web"

#   tags = var.tags
# }

# # Custom Domain and SSL (Optional)
# resource "azurerm_app_service_custom_hostname_binding" "main" {
#   count               = var.custom_domain != null ? 1 : 0
#   hostname            = var.custom_domain
#   app_service_name    = local.app_service_name
#   resource_group_name = var.resource_group_name
# }

# resource "azurerm_app_service_managed_certificate" "main" {
#   count                      = var.custom_domain != null ? 1 : 0
#   custom_hostname_binding_id = azurerm_app_service_custom_hostname_binding.main[0].id
# }

# resource "azurerm_app_service_certificate_binding" "main" {
#   count               = var.custom_domain != null ? 1 : 0
#   hostname_binding_id = azurerm_app_service_custom_hostname_binding.main[0].id
#   certificate_id      = azurerm_app_service_managed_certificate.main[0].id
#   ssl_state           = "SniEnabled"
# }

# locals {
#   app_service_name = var.os_type == "Linux" ? azurerm_linux_web_app.main[0].name : azurerm_windows_web_app.main[0].name
# }