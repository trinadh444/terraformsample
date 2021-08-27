variable "resourcegroup" {
  description = "name of the resource group"
  type = string
  default     = ""
}

variable "location" {
  description = "location"
  type = string
  default     = ""
}

variable "vnetname" {
  description = "name of the vnet"
  type = string
  default     = ""
}

variable "subnet" {
  description = "name of the subnet"
  type = string
  default     = ""
}

variable "publicipname" {
  description = "name of the Public IP"
  type = string
  default     = ""
}

variable "storageaccountname" {
  description = "name of the Storage Account"
  type = string
  default     = ""
}

variable "vmname" {
  description = "name of the Virtual Machine"
  type = string
  default     = ""
}

variable "vmsize" {
  description = "Virtual Machine Size"
  type = string
  default     = ""
}

variable "adminusername" {
  description = "adminusername"
  type = string
  default     = ""
}

variable "adminpassword" {
  description = "adminpassword"
  type = string
  default     = ""
}

variable "publisher" {
  description = "publisher of the OS"
  type = string
  default     = ""
}

variable "offer" {
  description = "offer of the OS"
  type = string
  default     = ""
}

variable "sku" {
  description = "sku"
  type = string
  default     = ""
}

variable "Osversion" {
  description = "version of the OS"
  type = string
  default     = ""
}