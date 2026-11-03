variable "subscription_id" {
  description = "Azure subscription ID."
  type        = string
}

variable "project" {
  description = "Short project identifier used in resource names."
  type        = string
  default     = "sokoni"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "East US"
}

variable "storage_account_name" {
  description = "Globally unique lowercase storage account name."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "The storage account name must be 3-24 lowercase letters or digits."
  }
}

variable "storage_replication_type" {
  description = "Storage redundancy setting."
  type        = string
  default     = "ZRS"

  validation {
    condition     = contains(["LRS", "ZRS", "GRS", "RAGRS", "GZRS", "RAGZRS"], var.storage_replication_type)
    error_message = "Use LRS, ZRS, GRS, RAGRS, GZRS, or RAGZRS."
  }
}

variable "container_names" {
  description = "Private ADLS containers."
  type        = list(string)
  default     = ["raw", "processed", "curated"]
}

variable "vnet_address_space" {
  description = "VNet address ranges."
  type        = list(string)
  default     = ["10.40.0.0/16"]
}

variable "data_subnet_address_prefixes" {
  description = "Address range for the data subnet."
  type        = list(string)
  default     = ["10.40.1.0/24"]
}

variable "data_contributor_principal_ids" {
  description = "Service principal object IDs granted Blob Data Contributor."
  type        = list(string)
  default     = []
}

variable "data_reader_principal_ids" {
  description = "Service principal object IDs granted Blob Data Reader."
  type        = list(string)
  default     = []
}

variable "log_retention_days" {
  description = "Log Analytics retention in days."
  type        = number
  default     = 90
}

variable "tags" {
  description = "Additional resource tags."
  type        = map(string)
  default     = {}
}
