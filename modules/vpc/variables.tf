variable "vpc_cidr" {
  description = "The CIDR block of the vpc"
}

variable "public_subnets_cidr" {
  type        = list(any)
  description = "The CIDR block for the public subnet"
}

variable "private_subnets_cidr" {
  type        = list(any)
  description = "The CIDR block for the private subnet"
}

variable "region" {
  description = "The region to launch the bastion host"
}
variable "availability_zones" {
  type        = list(any)
  description = "The az that the resources will be launched"
  default     = ["ap-southeast-1a", "ap-southeast-1b"]
}
variable "az_shortname" {
  type        = list(any)
  description = "The az shortname"
}

variable "stage" {
  description = "Stage Name"
}

variable "project_name" {
  description = "Project Name"
  type        = string
}

# variable "dev_accepter_vpc_id" {
#   description = "Accepter VPC ID"
#   type        = string
# }

# # variable "dev_destination_cidr_block" {
# #   description = "Dev Environment Destination CIDR block"
# #   type        = string
# # }
# # variable "dev_account_id" {
# #   description = "Dev Account ID"
# #   type        = string
# # }

