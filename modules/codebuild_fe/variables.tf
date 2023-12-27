variable "region" {
  description = "AWS region..."
}

variable "environment" {
  description = "environment"
}
variable "project_name" {
  description = "The project name..."
}

variable "codebuild_project_name" {
  description = "The build project name..."
}


variable "codecommit_fe_url" {
  description = "Frontend repository URL..."
}


variable "fe_repo_name" {
  description = "Frontend repository name..."
}
variable "compute_type" {
  type        = string
  description = "Information about the compute resources the build project will use."
  default     = "BUILD_GENERAL1_SMALL"
}

variable "codebuild_role" {
  description = "codebuild role ARN"
}

variable "secret_manager_arn" {
  description = "Secret Manager ARN"
}
variable "stage" {
  description = "stage"
}
variable "build_branch" {
  description = "Build branch"
}
