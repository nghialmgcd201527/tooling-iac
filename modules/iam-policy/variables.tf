variable "region" {
  default = "ap-southeast-1"
}

variable "codebuild_role" {
  type    = string
  default = null
}

variable "account_id" {
  type    = string
  default = null
}
variable "application_account_id" {
  type    = string
  default = null
}
variable "application_account_id_qa" {
  type    = string
  default = null
}

variable "tags" {
  type        = map(string)
  description = "Optional Tags"
  default     = {}
}

variable "iam_devops_group" {
  type        = string
  description = "DevOps Group"
  default     = null
}

variable "iam_maintainers_group" {
  type        = string
  description = "Maintaines Group"
  default     = null
}

variable "iam_devs_group" {
  type        = string
  description = "Dev Group"
  default     = null
}
