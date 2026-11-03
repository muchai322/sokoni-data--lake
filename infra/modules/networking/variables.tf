variable "name" {
  description = "Virtual network name."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for network resources."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "address_space" {
  description = "VNet address ranges."
  type        = list(string)
}

variable "subnet_name" {
  description = "Data subnet name."
  type        = string
  default     = "snet-data"
}

variable "subnet_address_prefixes" {
  description = "Data subnet address ranges."
  type        = list(string)
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = {}
}
