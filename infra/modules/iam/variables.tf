variable "storage_account_id" {
  description = "Storage account resource ID to scope data roles."
  type        = string
}

variable "data_contributor_principal_ids" {
  description = "Entra service principal object IDs granted Blob Data Contributor."
  type        = list(string)
  default     = []
}

variable "data_reader_principal_ids" {
  description = "Entra service principal object IDs granted Blob Data Reader."
  type        = list(string)
  default     = []
}
