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

variable "disk_name" {
  description = "Name of the disk to create / attach"
  default     = "datadisk"
}

variable "virtual_machine_id" {
  description = "ID of the VM to attach the disk to"
  default     = ""
}

variable "disk_type" {
  description = "What type of disk do you want to create?"
  default     = "Standard_LRS"
}

variable "disk_size" {
  description = "Size of the disk you want to create in GB"
  default     = "10"
}

variable "disk_create_option" {
  description = ""
  default     = "Empty"
}

variable "lun" {
  description = ""
  default     = "10"
}

variable "caching" {
  description = ""
  default     = "ReadWrite"
}
