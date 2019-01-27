variable "resource_group_name" {
  description = "The name of the resource group we want to use"
  default     = ""
}

variable "location" {
  description = "The location/region where we are crrating the resource"
  default     = ""
}

variable "tags" {
  description = "The tags to associate the resource we are creating"
  type        = "map"
  default     = {}
}

# Everything below is for the module

variable "name" {
  description = "Name of the vault and policy"
  default     = ""
}

variable "sku" {
  description = "Name of the sku to use"
  default     = "Standard"
}

variable "frequency" {
  description = "When to backup?"
  default     = "Daily"
}

variable "time" {
  description = "What time to backup?"
  default     = "23:00"
}

variable "retention_daily" {
  description = "How many backups to keep?"
  default     = "7"
}
