locals {
  project_prefix    = lower(var.project_prefix)
  project_env       = lower(var.project_env)
  sns_topic_name    = "${local.project_env}-${local.project_prefix}-${lower(var.sns_topic_name)}"
  sns_rest_api_name = "${local.project_env}-${local.project_prefix}-${lower(var.sns_rest_api_name)}"
}