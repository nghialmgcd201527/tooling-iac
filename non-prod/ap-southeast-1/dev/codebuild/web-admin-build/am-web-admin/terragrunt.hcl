locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  # Extract out common variables for reuse
  env            = local.environment_vars.locals.environment
  region         = local.region_vars.locals.aws_region
  web_repo       = local.environment_vars.locals.am_web_admin_repo
  default_branch = local.environment_vars.locals.default_branch
  stage          = local.environment_vars.locals.stage
  build_branch   = local.environment_vars.locals.build_branch
  project_name   = local.environment_vars.locals.project_name

}


dependencies {
  paths = ["../../../iam-policy", "../../../codecommit/web-admin-repo/am-web-admin"]
}

dependency "web" {
  config_path = find_in_parent_folders("codecommit/web-admin-repo/am-web-admin")
  mock_outputs = {
    codecommit_fe_url = "temporary-url"
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
  source = "${path_relative_from_include()}//modules/codebuild_fe"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  region                 = local.region
  environment            = local.env
  fe_repo_name           = local.web_repo
  codebuild_project_name = local.web_repo
  codebuild_role         = dependency.iam-policy.outputs.codebuild_arn_1
  codecommit_fe_url      = dependency.web.outputs.codecommit_fe_url
  secret_manager_arn     = dependency.secret_manager.outputs.secret_manager_arn
  stage                  = local.stage
  build_branch           = local.build_branch
  project_name           = local.project_name
  compute_type           = "BUILD_GENERAL1_MEDIUM"
}
