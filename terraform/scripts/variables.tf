locals {
  common_tags = {
    ProjectID = var.awslz_project_id
    Environment = var.awslz_environment
    AccountID = var.awslz_account_id
  }
}

variable "aws_default_region" {
  type        = string
  description = "Default region for the landing zone"
}

variable "aws_access_key_id" {
  type        = string
  description = "access key"
}

variable "aws_secret_access_key" {
  type        = string
  description = "access key"
}

variable "tag_key_project_id" {
<<<<<<< terraform/scripts/variables.tf
  type = string
  default = "ProjectId"
}
variable "tag_key_environment" {
  type = string
  default = "Environment"
}
variable "tag_key_account_id" {
  type = string
  default = "AccountId"
=======
  type        = string
  default     = "project_id"
}
variable "tag_key_environment" {
  type        = string
  default     = "environment"
}
variable "tag_key_account_id" {
  type        = string
  default     = "account_id"
>>>>>>> terraform/scripts/variables.tf
}
variable "tag_key_name" {
  type        = string
  default     = "name"
}
variable "awslz_project_id" {
  type        = string
  default     = "11111"
}
variable "awslz_environment" {
  type        = string
  default     = "DEV"
}
variable "awslz_account_id" {
  type        = string
  default     = "22222"
}


variable "aws_organizations_account_sharedservices_name" {
  description = "Shared Services details"
  default     = "sharedservice"
}
variable "aws_organizations_account_sharedservices_email" {
<<<<<<< terraform/scripts/variables.tf
    description = "Shared Services details"
    default = "test.gft.aws.01@gmail.com"
=======
  description = "Shared Services details"
  default     = "sharedservice@nn.com"
>>>>>>> terraform/scripts/variables.tf
}
variable "aws_organizations_account_logarchive_name" {
  description = "Log Archive accounts details"
  default     = "logarchive"
}
variable "aws_organizations_account_logarchive_email" {
<<<<<<< terraform/scripts/variables.tf
    description = "Log Archive accounts details"
    default = "test.gft.aws.02@gmail.com"
}
variable "aws_organizations_account_security_name" {
    description = "Security accounts details"
    default = "security"
}
variable "aws_organizations_account_security_email" {
    description = "Security accounts details"
    default = "test.gft.aws.03@gmail.com"
=======
  description = "Log Archive accounts details"
  default     = "logarchive@nn.com"
>>>>>>> terraform/scripts/variables.tf
}
variable "org_tags" {
  default = {} 
}