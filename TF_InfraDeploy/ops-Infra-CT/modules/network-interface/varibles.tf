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
  description = "Name of the nic to create"
  default     = ""
}

variable "vnet_name" {
  description = "Name of the vNet where the nic will be created"
  default     = ""
}

variable "subnet_name" {
  description = "Name of the subnet where the nic will be created"
  default     = ""
}

variable "nsg_id" {
  description = "ID of the NSG which should be assigned to the NIC"
  default     = ""
}

variable "asg_ids" {
  description = ""
  type        = "list"
  default     = []
}

variable "type" {
  description = "Should the address assigned to this NIC be public or private? [public or private]"
  default     = "private"
}

variable "public_ip_id" {
  description = "ID of the public ip address which should be assigned to the NIC"
  default     = ""
}

variable "private_ip_address_allocation" {
  description = "Should the private ip be dynamic or static? [dynamic or static]"
  default     = "dynamic"
}

variable "private_ip_address" {
  description = "If static, what IP address should be assigned?"
  default     = ""
}

variable "nb_nics" {
  description = "This is used to decide if a nic should be created, leave at the default value"
  default     = "1"
}
