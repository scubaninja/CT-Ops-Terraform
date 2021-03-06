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

variable "public_ip_name" {
  description = "Name of the public ip to create"
  default     = ""
}

variable "public_ip_allocation" {
  description = "Should the public ip be Dynamic or Static?"
  default     = "Dynamic"
}
