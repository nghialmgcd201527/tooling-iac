variable "repo_branch" {
  description = "Branch Name..."
}

variable "codebuild_project_name" {
  description = "Build project name..."
}
variable "project_name" {
  description = "Project name..."
}

variable "repo_name" {
  description = "Codecommit Repository Name..."
}
variable "secret_manager_arn" {
  description = "Secret Manager ARN."
}

variable "codepipeline_role" {
  description = "Codepipeline Role ARN..."
}

variable "codecommit_arn" {
  description = "Codecommit ARN..."
}

variable "is_force_destroy" {
  type        = bool
  description = "A boolean that indicates all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  default     = false
}

variable "stage" {
  type        = string
  description = "Stage name"
}



