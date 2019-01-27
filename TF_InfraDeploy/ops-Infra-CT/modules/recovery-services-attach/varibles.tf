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

variable "recovery_vault_name" {
  description = "Name of the vault we want to use"
  default     = ""
}

variable "backup_policy_id" {
  description = "ID of the policy to attach"
  default     = ""
}

variable "virtual_machine_id" {
  description = "ID of the VM which needs to be backed up"
  default     = ""
}
