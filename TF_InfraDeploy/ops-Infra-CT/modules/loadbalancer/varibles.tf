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
  description = "Name of the load balancer"
  default     = ""
}

variable "public_ip_id" {
  description = "ID of the public ip address which should be assigned to the load balancer"
  default     = ""
}

variable "subnet_id" {
  description = "ID of the subnet where the load balancer should be placed"
  default     = ""
}

variable "remote_ports" {
  description = "Remote ports / Nat rules for the Load Balancer using this format name = [protocol, frontend_port, backend_port]"
  type        = "list"
  default     = []
}

variable "lb_ports" {
  description = "Remote ports / Nat rules for the Load Balancer using this format name = [protocol, frontend_port, backend_port]"
  type        = "list"
  default     = []
}

variable "type" {
  type        = "string"
  description = "(Optional) Defined if the loadbalancer is private or public"
  default     = "public"
}

variable "frontend_subnet_id" {
  description = "(Optional) Frontend subnet id to use when in private mode"
  default     = ""
}

variable "frontend_private_ip_address" {
  description = "(Optional) Private ip address to assign to frontend. Use it with type = private"
  default     = ""
}

variable "frontend_private_ip_address_allocation" {
  description = "(Optional) Frontend ip allocation type (Static or Dynamic)"
  default     = "Dynamic"
}
