locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  # Extract out common variables for reuse
  env            = local.environment_vars.locals.environment
  region         = local.region_vars.locals.aws_region
  web_repo       = local.environment_vars.locals.rm_web_admin_repo
  default_branch = local.environment_vars.locals.default_branch
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "${path_relative_from_include()}//modules/codecommit_fe"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  fe_repo_name   = local.web_repo
  fe_repo_branch = local.default_branch
}

# dependencies {
#   paths = ["../terraform_aws_vpc_network"]
# }
