module "aws_lz_aggregate_security_sns_topic" {
  source = "./modules/snstopic"
  
   providers = {
    aws = aws.security-account
  } 

  sns_topic_name = var.aggregate_topic_name
  required_tags = { (var.tag_key_project_id) = var.awslz_proj_id, (var.tag_key_environment) = var.awslz_environment, (var.tag_key_account_id) = module.aws_lz_account_security.account_id, (var.tag_key_name) = "Aggregate Security" }
}

############################ SECURITY ADMIN ROLES #####################################

data "aws_iam_policy_document" "aws_lz_assume_role_security" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.security_account_id}:root"]
    }

    effect = "Allow"
  }
}


module "aws_lz_iam_security_admin_master" {
  source = "./modules/iam"
  role_name = "${var.security_role_name}${local.current_account_id}"
  assume_role_policy = "${data.aws_iam_policy_document.aws_lz_assume_role_security.json}"
  role_tags = { (var.tag_key_project_id) = var.awslz_proj_id, (var.tag_key_environment) = var.awslz_environment, (var.tag_key_account_id) = local.current_account_id }

  #attachment
  policy_attach_name = "${var.policy_attach_security_admin}${local.current_account_id}"
  policy_attach_roles = ["${var.security_role_name}${local.current_account_id}"]
  policy_arn = var.administrator_access_arn
}