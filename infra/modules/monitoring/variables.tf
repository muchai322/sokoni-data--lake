variable "workspace_name" {
  description = "Log Analytics workspace name."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for monitoring resources."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "retention_in_days" {
  description = "Log Analytics retention between 30 and 730 days."
  type        = number
  default     = 90

  validation {
    condition     = var.retention_in_days >= 30 && var.retention_in_days <= 730
    error_message = "Retention must be between 30 and 730 days."
  }
}

variable "diagnostic_name_prefix" {
  description = "Prefix for diagnostic setting names."
  type        = string
}

variable "diagnostic_target_ids" {
  description = "Map of stable diagnostic target keys to Azure resource IDs."
  type        = map(string)
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = {}
}
