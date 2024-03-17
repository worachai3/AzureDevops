# Project variables
variable "location" {
  type = string
  description = "The location for the deployment"
  default = "West US"
}

variable "rsgname" {
  type = string
  description = "Resource Group name"
  default = "TerraformRG"
}

variable "stgactname" {
  type = string
  description = "Storage Account name name"
}