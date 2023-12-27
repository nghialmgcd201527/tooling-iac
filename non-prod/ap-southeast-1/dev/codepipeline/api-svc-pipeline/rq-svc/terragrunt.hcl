locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  # Extract out common variables for reuse
  env          = local.environment_vars.locals.environment
  region       = local.region_vars.locals.aws_region
  build_branch = local.environment_vars.locals.build_branch
  stage        = local.environment_vars.locals.stage
  project_name = local.environment_vars.locals.project_name
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "${path_relative_from_include()}//modules/codepipeline"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependency "iam-policy" {
  config_path = find_in_parent_folders("iam-policy")
  mock_outputs = {
    codepipeline_arn = "arn:aws:iam::111111111111:role/codepipeline-role"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

dependency "codebuild" {
  config_path = find_in_parent_folders("codebuild/api-svc-build/rq-svc")
  mock_outputs = {
    codebuild_name = "temporary-name"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

dependency "codecommit" {
  config_path = find_in_parent_folders("codecommit/api-svc-repo/rq-svc")
  mock_outputs = {
    codecommit_be_repo = "temporary-repo"
    codecommit_be_arn = "temporary-repo"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

dependency "secret_manager" {
  config_path = find_in_parent_folders("secret_manager")
  mock_outputs = {
    secret_manager_arn = "arn:aws:secretsmanager:region:111111111111:secret:secret-id"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

dependencies {
  paths = ["../../../iam-policy", "../../../secret_manager", "../../../codecommit/api-svc-repo/rq-svc", "../../../codebuild/api-svc-build/rq-svc"]
}


# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  repo_name              = dependency.codecommit.outputs.codecommit_be_repo
  codebuild_project_name = dependency.codebuild.outputs.codebuild_name
  repo_branch            = local.build_branch
  codepipeline_role      = dependency.iam-policy.outputs.codepipeline_arn
  stage                  = local.stage
  secret_manager_arn     = dependency.secret_manager.outputs.secret_manager_arn
  project_name           = local.project_name
  codecommit_arn         = dependency.codecommit.outputs.codecommit_be_arn
}

# dependencies {
#   paths = ["../terraform_aws_vpc_network"]
# }
