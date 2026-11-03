locals {
  name_prefix = "${var.project}-${var.environment}"
  common_tags = merge(var.tags, {
    project     = var.project
    environment = var.environment
    managed_by  = "terraform"
  })
}

module "resource_group" {
  source   = "../../modules/resource-group"
  name     = "rg-${local.name_prefix}"
  location = var.location
  tags     = local.common_tags
}

module "networking" {
  source                  = "../../modules/networking"
  name                    = "vnet-${local.name_prefix}"
  resource_group_name     = module.resource_group.name
  location                = module.resource_group.location
  address_space           = var.vnet_address_space
  subnet_address_prefixes = var.data_subnet_address_prefixes
  tags                    = local.common_tags
}

module "storage" {
  source              = "../../modules/storage"
  name                = var.storage_account_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  replication_type    = var.storage_replication_type
  allowed_subnet_ids  = [module.networking.subnet_id]
  container_names     = var.container_names
  tags                = local.common_tags
}

module "iam" {
  source                         = "../../modules/iam"
  storage_account_id             = module.storage.id
  data_contributor_principal_ids = var.data_contributor_principal_ids
  data_reader_principal_ids      = var.data_reader_principal_ids
}

module "monitoring" {
  source                 = "../../modules/monitoring"
  workspace_name         = "log-${local.name_prefix}"
  resource_group_name    = module.resource_group.name
  location               = module.resource_group.location
  retention_in_days      = var.log_retention_days
  diagnostic_name_prefix = local.name_prefix
  diagnostic_target_ids  = { storage = module.storage.id }
  tags                   = local.common_tags
}
