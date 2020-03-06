

module "aws_lz_config_sns_topic" {
  source = "./modules/snstopic"
  
   providers = {
    aws = aws.sandbox-account
  } 

  sns_topic_name = var.config_topic_name
  required_tags = { (var.tag_key_project_id) = var.awslz_proj_id, (var.tag_key_environment) = var.awslz_environment, (var.tag_key_account_id) = module.aws_lz_account_sandbox.account_id, (var.tag_key_name) = "config" }
}

module "aws_lz_config_service" {
  source = "./modules/config/config-service"

  providers = {
    aws = aws.sandbox-account
  } 

  config_name = var.config_name
  config_logs_bucket = module.aws_lz_config_bucket.bucket_name_log
  config_logs_bucket_arn = module.aws_lz_config_bucket.bucket_log_arn
  s3_log_prefix = module.aws_lz_config_bucket.s3_log_prefix
  topic_account_id = module.aws_lz_account_sandbox.account_id
  #sns_topic_arn = module.aws_lz_config_sns_topic.topic_arn
  sns_topic_arn = "arn:aws:sns:us-west-2:971696596064:aws_lz_config_sns_topic"
  config_tags = { (var.tag_key_project_id) = var.awslz_proj_id, (var.tag_key_environment) = var.awslz_environment, (var.tag_key_account_id) = module.aws_lz_account_sandbox.account_id, (var.tag_key_name) = "config" }
}

/* module "aws_lz_config_aggregator" {
  source = "./modules/config/config-aggregator"

  config_name = var.config_name
  region = local.region
  authorization_account_id = local.current_account_id
  config_tags = { (var.tag_key_project_id) = var.awslz_proj_id, (var.tag_key_environment) = var.awslz_environment, (var.tag_key_account_id) = local.current_account_id, (var.tag_key_name) = "config" }
}

module "aws_lz_config_rules" {
  source = "./modules/config/config-rules"
  recorder_main = module.aws_lz_config_service.recorder_main
  delivery_channel = module.aws_lz_config_service.delivery_channel
} */