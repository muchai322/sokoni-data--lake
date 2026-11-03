resource "azurerm_role_assignment" "data_contributor" {
  for_each             = toset(var.data_contributor_principal_ids)
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = each.value
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "data_reader" {
  for_each             = toset(var.data_reader_principal_ids)
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = each.value
  principal_type       = "ServicePrincipal"
}
