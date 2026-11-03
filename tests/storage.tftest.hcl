mock_provider "azurerm" {}

run "storage_account_and_containers_are_configured" {
  command = plan

  assert {
    condition     = module.storage.name == "sokonitestdata001"
    error_message = "The configured storage account name should be passed through."
  }

  assert {
    condition     = length(module.storage.container_names) == 3
    error_message = "The baseline should create three private data lake containers."
  }
}
