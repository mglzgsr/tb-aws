module "aws_lz_aggregate_security_sns_topic" {
  source = "./modules/snstopic"
  
   providers = {
    aws = aws.security-account
  } 

  sns_topic_name = var.aggregate_topic_name
  required_tags = { (var.tag_key_project_id) = var.awslz_proj_id, (var.tag_key_environment) = var.awslz_environment, (var.tag_key_account_id) = module.aws_lz_account_security.account_id, (var.tag_key_name) = "Aggregate Security" }
}

 module "aws_lz_lambda_role" {
   source = "./modules/iam"
 
   providers = {
     aws = aws.security-account
   }

   role_name = var.lambda_role_name
   assume_role_policy = "${data.aws_iam_policy_document.aws_lz_lambda_policy.json}"
   role_tags = { (var.tag_key_project_id) = var.awslz_proj_id, (var.tag_key_environment) = var.awslz_environment, (var.tag_key_account_id) = local.security_account_id }

   #attachment
  role_policy_attach = true
  policy_arn = local.administrator_access_arn
 }
module "aws_lz_lambda_guarduty_findings" {
  source = "./modules/lambda"

  providers = {
    aws = aws.security-account
  }

  file_name = "${data.archive_file.lambda_guardduty_findings.output_path}"
  code_hash = "${data.archive_file.lambda_guardduty_findings.output_base64sha256}"
  function_name = var.function_name
  function_handler = "${var.file_name}.${var.function_handler}"
  function_role = module.aws_lz_lambda_role.role_arn
  function_description = var.function_description
  function_runtime = var.function_runtime
  tags = { (var.tag_key_project_id) = var.awslz_proj_id, (var.tag_key_environment) = var.awslz_environment, (var.tag_key_account_id) = local.security_account_id }
}


data "aws_iam_policy_document" "aws_lz_lambda_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }

    effect = "Allow"
  }
}

data "archive_file" "lambda_guardduty_findings" {
  type        = "zip"
  output_path = "/tmp/lambda_guardduty_findings.zip"
  source {
    content  = <<EOF
import json
import boto3

session = boto3.Session()
client = session.client('sns')

def lambda_handler(event, context):
    records = event['Records']
    notif = records[0]
    sns_content = notif["Sns"]
    text = sns_content["Message"]
    response = client.publish(
        TopicArn = '${module.aws_lz_aggregate_security_sns_topic.topic_arn}',
        Message = text,
        Subject = 'Guardduty finding'
    )
EOF
    filename = "${var.file_name}.py"
  }
}
