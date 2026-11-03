resource "azurerm_log_analytics_workspace" "this" {
  name                         = var.workspace_name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  sku                          = "PerGB2018"
  retention_in_days            = var.retention_in_days
  local_authentication_enabled = false
  tags                         = var.tags
}

data "azurerm_monitor_diagnostic_categories" "targets" {
  for_each    = var.diagnostic_target_ids
  resource_id = each.value
}

resource "azurerm_monitor_diagnostic_setting" "targets" {
  for_each                   = var.diagnostic_target_ids
  name                       = "${var.diagnostic_name_prefix}-${each.key}"
  target_resource_id         = each.value
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

  dynamic "enabled_log" {
    for_each = data.azurerm_monitor_diagnostic_categories.targets[each.key].log_category_types
    content {
      category = enabled_log.value
    }
  }

  dynamic "enabled_metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.targets[each.key].metrics
    content {
      category = enabled_metric.value
    }
  }
}
