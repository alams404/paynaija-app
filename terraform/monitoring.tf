resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-3tier-project"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_monitor_diagnostic_setting" "backend_diag" {
  name                       = "diag-backend"
  target_resource_id         = azurerm_container_group.backend.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  enabled_log {
    category = "ContainerInstanceLog"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

resource "azurerm_monitor_action_group" "alerts" {
  name                = "ag-3tier-alerts"
  resource_group_name = azurerm_resource_group.rg.name
  short_name          = "aciAlerts"

  email_receiver {
    name          = "primary"
    email_address = "you@example.com" # replace with your email
  }
}

resource "azurerm_monitor_metric_alert" "backend_cpu_alert" {
  name                = "alert-backend-cpu"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [azurerm_container_group.backend.id]
  description         = "Backend container CPU usage high"

  criteria {
    metric_namespace = "Microsoft.ContainerInstance/containerGroups"
    metric_name      = "CpuUsage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.alerts.id
  }
}
