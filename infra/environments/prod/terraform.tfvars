project     = "sokoni"
environment = "prod"
location    = "East US"

# Replace with a globally unique lowercase name before deployment.
storage_account_name = "sokoniproddata001"

storage_replication_type     = "GZRS"
container_names              = ["raw", "processed", "curated"]
vnet_address_space           = ["10.50.0.0/16"]
data_subnet_address_prefixes = ["10.50.1.0/24"]
log_retention_days           = 365

tags = {
  owner = "data-platform"
}
