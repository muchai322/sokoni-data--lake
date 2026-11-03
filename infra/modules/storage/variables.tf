variable "name" {
  description = "Globally unique lowercase storage account name."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.name))
    error_message = "The storage account name must be 3-24 lowercase letters or digits."
  }
}

variable "resource_group_name" {
  description = "Resource group for the storage account."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "replication_type" {
  description = "Storage redundancy setting."
  type        = string
  default     = "ZRS"

  validation {
    condition     = contains(["LRS", "ZRS", "GRS", "RAGRS", "GZRS", "RAGZRS"], var.replication_type)
    error_message = "Use LRS, ZRS, GRS, RAGRS, GZRS, or RAGZRS."
  }
}

variable "allowed_subnet_ids" {
  description = "Subnet IDs allowed by storage firewall."
  type        = list(string)
}

variable "container_names" {
  description = "Private containers to provision."
  type        = list(string)
  default     = ["raw", "processed", "curated"]
}

variable "blob_retention_days" {
  description = "Soft-delete retention for blobs and containers."
  type        = number
  default     = 30
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = {}
}
