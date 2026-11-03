project     = "sokoni"
environment = "dev"
location    = "East US"

# Replace with a globally unique lowercase name before deployment.
storage_account_name = "sokonidevdata001"

storage_replication_type     = "ZRS"
container_names              = ["raw", "processed", "curated"]
vnet_address_space           = ["10.40.0.0/16"]
data_subnet_address_prefixes = ["10.40.1.0/24"]
log_retention_days           = 90

tags = {
  owner = "data-platform"
}
