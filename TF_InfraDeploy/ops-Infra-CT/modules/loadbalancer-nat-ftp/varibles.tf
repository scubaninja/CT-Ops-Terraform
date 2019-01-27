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

variable "frontend_ip_configuration_name" {
  description = "Name of the front end configuration"
  default     = ""
}

variable "no_of_ports" {
  description = "How may ports to increment by"
  default     = ""
}

variable "loadbalancer_id" {
  description = "ID of the load balancer"
  default     = ""
}

variable "name" {
  description = "Name of the service"
  default     = ""
}

variable "protocol" {
  description = "Name of the service"
  default     = "tcp"
}

variable "start_port" {
  description = "Name of the service"
  default     = ""
}

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

variable "network_security_group_name" {
  description = ""
  default     = ""
}
