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
  description = "Name of the network security group to create"
  default     = ""
}

# Custom security rules
# [priority, direction, access, protocol, source_port_range, destination_port_range, description]"
# All the fields are required.
variable "rules_locked_down" {
  description = "Security rules for the network security group using this format name = [priority, direction, access, protocol, source_port_range, destination_port_range, source_address_prefix, destination_address_prefix]"
  type        = "list"
  default     = []
}

variable "rules_groups" {
  description = "Security rules for the network security group using this format name = [priority, direction, access, protocol, source_port_range, destination_port_range, source_address_prefix, destination_address_prefix]"
  type        = "list"
  default     = []
}

variable "rules_open" {
  description = "Security rules for the network security group using this format name = [priority, direction, access, protocol, source_port_range, destination_port_range, source_address_prefix, destination_address_prefix]"
  type        = "list"
  default     = []
}

variable "rules_locked_down_no" {
  description = ""
  default     = "0"
}

variable "rules_open_no" {
  description = ""
  default     = "0"
}

variable "rules_groups_no" {
  description = ""
  default     = "0"
}

variable "application_security_group_ids" {
  description = ""
  default     = ""
}
