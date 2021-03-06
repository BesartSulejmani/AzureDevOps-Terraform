# variables.tf

variable "prefix" {
  type        = string
  description = "Prefix differentiator"
}

variable "environment" {
  type        = string
  description = "Environment differentiator"
}

variable "location" {
  type        = string
  description = "Resource location"
}

variable "tags" {
  type = map

  default = {
    Environment = "Terraform"
    Dept        = "Engineering"
  }
}