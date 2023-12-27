locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  # Extract out common variables for reuse
  env          = local.environment_vars.locals.environment
  region       = local.region_vars.locals.aws_region
  stage        = local.environment_vars.locals.stage
  service_repo = local.environment_vars.locals.bd_web_api_repo
  build_branch = local.environment_vars.locals.build_branch
}


dependencies {
  paths = ["../../../vpc", "../../../iam-policy", "../../../secret_manager", "../../../codecommit/api-svc-repo/bd-svc"]
}

dependency "codecommit" {
  config_path = find_in_parent_folders("codecommit/api-svc-repo/bd-svc")
  mock_outputs = {
    codecommit_be_url = "temporary-url"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

dependency "vpc" {
  config_path = find_in_parent_folders("vpc")
  mock_outputs = {
    vpc_id                 = "vpc-1234abcd1234abcde"
    private_subnet_ids     = ["subnet-1234abcdd1234abcd", "subnet-1234abcdd1234abcd"]
    private_security_group = "sg-0ea3cdabcd1234"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

dependency "iam-policy" {
  config_path = find_in_parent_folders("iam-policy")
  mock_outputs = {
    codebuild_arn = "arn:aws:iam::111111111111:role/codebuild-role"
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

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "${path_relative_from_include()}//modules/codebuild_be"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  region                 = local.region
  environment            = local.env
  be_repo_name           = local.service_repo
  codebuild_project_name = local.service_repo
  codebuild_role         = dependency.iam-policy.outputs.codebuild_arn
  codecommit_be_url      = dependency.codecommit.outputs.codecommit_be_url
  secret_manager_arn     = dependency.secret_manager.outputs.secret_manager_arn
  stage                  = local.stage
  build_branch           = local.build_branch
  compute_type           = "BUILD_GENERAL1_MEDIUM"
  vpc_id                 = dependency.vpc.outputs.vpc_id
  private_subnet_ids     = dependency.vpc.outputs.private_subnet_ids
  private_security_group = dependency.vpc.outputs.private_security_group
}
