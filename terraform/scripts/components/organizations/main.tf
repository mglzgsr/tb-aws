resource "aws_organizations_organization" "aws_lz_organization" {
  count = var.create_lz_organization ? 1 : 0

  aws_service_access_principals = var.aws_organizations_service_access_principals
  enabled_policy_types = var.aws_organizations_enable_policy_types
  feature_set = var.aws_organizations_feature_set
}

resource "aws_organizations_account" "aws_lz_account" {
  count = length(var.org_account_name) > 0 ? 1 : 0
  
  name  = var.org_account_name
  email = var.org_account_email
  tags = var.org_tags
}

resource "aws_organizations_organizational_unit" "aws_lz_ou" {
  count = length(var.ou_name) > 0 ? 1 : 0

  name      = var.ou_name
  parent_id = var.ou_parent_id
}

