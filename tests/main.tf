module "storage" {
  source = "../infra/modules/storage"

  name                = "sokonitestdata001"
  resource_group_name = "rg-sokoni-test"
  location            = "East US"
  replication_type    = "LRS"
  allowed_subnet_ids  = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/snet-data"]
  container_names     = ["raw", "processed", "curated"]
}
