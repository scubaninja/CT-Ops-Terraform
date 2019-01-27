# Everything below is for the module

variable "network_interface_id" {
  description = ""
  default     = ""
}

variable "ip_configuration_name" {
  description = ""
  default     = ""
}

variable "backend_address_pool_id" {
  description = ""
  default     = ""
}

variable "no_of_nat_rules" {
  description = ""
  default     = ""
}

variable "nat_rules" {
  type        = "list"
  description = ""
  default     = [""]
}
