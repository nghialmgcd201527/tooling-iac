locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  # Extract out common variables for reuse
  env    = local.environment_vars.locals.environment
  region = local.region_vars.locals.aws_region
  // dev_accepter_vpc_id        = local.environment_vars.locals.dev_accepter_vpc_id
  // dev_destination_cidr_block = local.environment_vars.locals.dev_destination_cidr_block
  vpc_cidr             = local.environment_vars.locals.vpc_cidr
  private_subnets_cidr = local.environment_vars.locals.private_subnets_cidr
  public_subnets_cidr  = local.environment_vars.locals.public_subnets_cidr
  project_name         = local.environment_vars.locals.project_name
  availability_zones   = ["${local.region_vars.locals.aws_region}a", "${local.region_vars.locals.aws_region}b"]
  az_shortname         = ["AZ A", "AZ B"]
  stage                = local.environment_vars.locals.stage
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "${path_relative_from_include()}//modules/vpc"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}


# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  environment          = local.env
  region               = local.region
  vpc_cidr             = local.vpc_cidr
  public_subnets_cidr  = local.public_subnets_cidr
  private_subnets_cidr = local.private_subnets_cidr
  availability_zones   = local.availability_zones
  az_shortname         = local.az_shortname
  stage                = local.stage
  project_name         = local.project_name
  // dev_destination_cidr_block = local.dev_destination_cidr_block
  // dev_accepter_vpc_id        = local.dev_accepter_vpc_id
}

# dependencies {
#   paths = ["../terraform_aws_vpc_network"]
# }
