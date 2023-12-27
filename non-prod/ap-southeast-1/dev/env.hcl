
# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.
locals {
  environment             = "develop"
  project_name            = "bizbone"
  web_app_repo            = "web-app"
  web_admin_repo          = "web-admin"
  web_component_repo      = "web-component"
  web_shared_repo      = "web-shared"
  web_identity_repo       = "web-identity"
  core_service_net_repo = "core-service-net"
  web_researching_repo       = "web-researching"
  // web_locale_repo         = "web-locale"
  // web_appointment_repo    = "web-appointment"
  default_branch          = "develop"
  stage                   = "dev"
  build_branch            = "develop"
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
  nestjs_auth_repo = "nestjs-auth"
  // nestjs_temporal_repo = "nestjs-temporal"
  nestjs_common_repo  = "nestjs-common"
  ts_common_repo      = "ts-common"
  nestjs_health_repo  = "nestjs-health-check"
  nestjs_logger_repo  = "nestjs-logger"
  nestjs_swagger_repo = "nestjs-swagger"
  viz_erp_nestjs_repo = "viz-erp-nestjs"
  viz_erp_reactjs_repo = "viz-erp-reactjs"
  viz_erp_serverless_repo = "viz-erp-serverless"
  #ECS
  account_service_repo   = "account-service"
  core_service_repo   = "core-service"
  // api_service_repo       = "api-service"
  application_account_id = "756955845548"
  application_account_id_qa = "565133770688"
  // accepter_vpc_id        = "vpc-09f653dcd9c2566ea"
  // destination_cidr_block = "10.222.0.0/16"
  vpc_cidr             = "10.120.0.0/16"
  private_subnets_cidr = ["10.120.1.0/24", "10.120.2.0/24"]
  public_subnets_cidr  = ["10.120.3.0/24", "10.120.4.0/24"]

  // Human Resources repo
  hr_web_admin_repo = "web-hr"
  hr_web_api_repo = "hr-service"

  // Recruitment Management repo
  rm_web_admin_repo = "web-rm"
  rm_web_api_repo = "rm-service"

  // Contract Management repo
  cm_web_admin_repo = "web-cm"
  cm_web_api_repo = "cm-service"
  v_cm_web_admin_repo = "web-cm-v"

  // Business Development repo
  bd_web_admin_repo = "web-bd"
  bd_web_api_repo = "bd-service"
  v_bd_web_admin_repo = "web-bd-v"

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

  // Accounting repo VueJS
  v_ac_web_admin_repo = "web-ac-v"
  // ac_web_api_repo = "ac-v-service"

  // Payroll
  pr_web_admin_repo = "web-pr"
  pr_web_api_repo = "pr-service"

  // Program Management
  pm_web_admin_repo = "web-pm"
  pm_web_api_repo = "pm-service"

  // Program Management
  rq_web_admin_repo = "web-request"
  rq_web_api_repo = "request-service"

  // Researching A LOI NGUYEN
  researching_web_admin_repo = "web-researching"
  researching_web_api_repo = " researching-service"
}