variable "region" {
  description = "AWS region..."
}

variable "environment" {
  description = "Name of environment"
}


variable "project_name" {
  description = "The project name..."
}
variable "codebuild_project_name" {
  description = "The build project name..."
}

variable "codecommit_be_url" {
  description = "Backend repository URL..."
}

variable "be_repo_name" {
  description = "Backend repository name..."
}

variable "codebuild_role" {
  description = "Codebuild role ARN"
}

variable "stage" {
  description = "Stage"
}
variable "image" {
  description = "codebuild image name"
  default     =  "aws/codebuild/standard:7.0"
}
variable "compute_type" {
  type        = string
  description = "Information about the compute resources the build project will use."
  default     = "BUILD_GENERAL1_SMALL"
}
variable "build_branch" {
  description = "Build branch"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
  default     = ""
}
variable "private_subnet_ids" {
  type        = list(any)
  description = "Private Subnet IDs"
  default     = []
}
variable "private_security_group" {
  type        = string
  description = "Private Security Group"
  default     = ""
}
