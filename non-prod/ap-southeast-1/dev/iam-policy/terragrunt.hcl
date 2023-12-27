locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  # Extract out common variables for reuse
  env                    = local.environment_vars.locals.environment
  region                 = local.region_vars.locals.aws_region
  aws_account_id         = local.account_vars.locals.aws_account_id
  application_account_id = local.environment_vars.locals.application_account_id
  application_account_id_qa = local.environment_vars.locals.application_account_id_qa
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "${path_relative_from_include()}//modules/iam-policy"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../iam-group"]
}

dependency "iam-group" {
  config_path = find_in_parent_folders("iam-group")
  mock_outputs = {
    iam_devops_group      = "temporary-group-1"
    iam_maintainers_group = "temporary-group-2"
    iam_devs_group = "temporary-group-3"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  region                 = local.region
  account_id             = local.aws_account_id
  application_account_id = local.application_account_id
  application_account_id_qa = local.application_account_id_qa
  iam_devops_group       = dependency.iam-group.outputs.iam_devops_group
  iam_maintainers_group  = dependency.iam-group.outputs.iam_maintainers_group
  iam_devs_group         = dependency.iam-group.outputs.iam_devs_group
}
