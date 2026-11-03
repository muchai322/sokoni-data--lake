variable "subscription_id" {
  description = "Azure subscription ID for bootstrap resources."
  type        = string
}

variable "location" {
  description = "Azure region for state resources."
  type        = string
  default     = "East US"
}

variable "state_resource_group_name" {
  description = "Resource group name for Terraform state and bootstrap Key Vault."
  type        = string
  default     = "rg-sokoni-tfstate"
}

variable "state_storage_account_name" {
  description = "Globally unique lowercase name for the state storage account."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.state_storage_account_name))
    error_message = "The storage account name must be 3-24 lowercase letters or digits."
  }
}

variable "key_vault_name" {
  description = "Globally unique name for the bootstrap Key Vault."
  type        = string
}

variable "state_replication_type" {
  description = "Replication mode for state storage."
  type        = string
  default     = "ZRS"

  validation {
    condition     = contains(["LRS", "ZRS", "GRS", "RAGRS"], var.state_replication_type)
    error_message = "Use LRS, ZRS, GRS, or RAGRS."
  }
}

variable "tags" {
  description = "Tags applied to bootstrap resources."
  type        = map(string)
  default = {
    project     = "sokoni-data-lake"
    environment = "bootstrap"
    managed_by  = "terraform"
  }
}
