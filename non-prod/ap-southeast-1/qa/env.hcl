
# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.
locals {
  environment             = "qa"
  project_name            = "bizbone"
  web_app_repo            = "web-app"
  web_admin_repo          = "web-admin"
  web_component_repo      = "web-component"
  web_shared_repo      = "web-shared"
  web_identity_repo       = "web-identity"
  // web_locale_repo         = "web-locale"
  // web_appointment_repo    = "web-appointment"
  default_branch          = "qa"
  stage                   = "qa"
  build_branch            = "qa"
  #serverless
  locale_service_repo         = "locale-service"
  // appointment_service_repo    = "appointment-service"
  email_service_repo          = "email-service"
  cognito_service_repo        = "cognito-trigger-service"
  scheduler_service_repo      = "scheduler-service"
  // sms_service_repo            = "sms-service"
  // notification_service_repo   = "notification-service"
  // audit_service_repo          = "audit-service"
  // file_service_repo           = "file-service"
  
  #library
  viz_erp_nestjs_repo = "viz-erp-nestjs"
  viz_erp_reactjs_repo = "viz-erp-reactjs"
  viz_erp_serverless_repo = "viz-erp-serverless"
  #ECS
  core_service_repo   = "core-service"
  application_account_id = "756955845548"
  // accepter_vpc_id        = "vpc-09f653dcd9c2566ea"
  // destination_cidr_block = "10.222.0.0/16"
  // vpc_cidr             = "10.120.0.0/16"
  // private_subnets_cidr = ["10.120.1.0/24", "10.120.2.0/24"]
  // public_subnets_cidr  = ["10.120.3.0/24", "10.120.4.0/24"]

  // Human Resources repo
  hr_web_admin_repo = "web-hr"
  hr_web_api_repo = "hr-service"

  // Recruitment Management repo
  rm_web_admin_repo = "web-rm"
  rm_web_api_repo = "rm-service"

  // Contract Management repo
  cm_web_admin_repo = "web-cm"
  cm_web_api_repo = "cm-service"

  // Business Development repo
  bd_web_admin_repo = "web-bd"
  bd_web_api_repo = "bd-service"

  // Administration Management repo
  am_web_admin_repo = "web-am"
  am_web_api_repo = "am-service"

  // Information Technology repo
  it_web_admin_repo = "web-it"
  it_web_api_repo = "it-service"

  // Time Keeping repo
  tk_web_admin_repo = "web-tk"
  tk_web_api_repo = "tk-service"

  // Accounting repo
  ac_web_admin_repo = "web-ac"
  ac_web_api_repo = "ac-service"

  //Payroll
  pr_web_admin_repo = "web-pr"
  pr_web_api_repo = "pr-service"
}