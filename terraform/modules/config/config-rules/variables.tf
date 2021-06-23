variable "recorder_main" {
  description = "Recorder"
  default     = ""
}

variable "delivery_channel" {
  description = "Delivery Channel"
  default     = ""
}

variable "config_max_execution_frequency" {
  description = "The maximum frequency with which AWS Config runs evaluations for a rule."
  type        = string
  default     = "TwentyFour_Hours"
}

variable "acm_days_to_expiration" {
  description = "Specify the number of days before the rule flags the ACM Certificate as noncompliant."
  default     = 14
}

variable "password_require_uppercase" {
  description = "Require at least one uppercase character in password."
  default     = true
}

variable "password_require_lowercase" {
  description = "Require at least one lowercase character in password."
  default     = true
}

variable "password_require_symbols" {
  description = "Require at least one symbol in password."
  default     = true
}

variable "password_require_numbers" {
  description = "Require at least one number in password."
  default     = true
}

variable "password_min_length" {
  description = "Password minimum length."
  default     = 14
}

variable "password_reuse_prevention" {
  description = "Number of passwords before allowing reuse."
  default     = 24
}

variable "password_max_age" {
  description = "Number of days before password expiration."
  default     = 90
}

variable "check_root_account_mfa_enabled" {
  description = "Enable root-account-mfa-enabled rule"
  default     = true
}

variable "check_guard_duty" {
  description = "Enable guardduty-enabled-centralized rule"
  default     = true
}

variable "check_rds_public_access" {
  description = "Enable rds-instance-public-access-check rule"
  default     = false
}

variable "check_multi_region_cloud_trail" {
  description = "Enable multi-region-cloud-trail-enabled rule"
  default     = false
}

variable "check_cloudtrail_enabled" {
  description = "Enable cloudtrail-enabled rule"
  default     = false
}

variable "check_cloud_trail_encryption" {
  description = "Enable cloud-trail-encryption-enabled rule"
  default     = false
}

variable "check_cloud_trail_log_file_validation" {
  description = "Enable cloud-trail-log-file-validation-enabled rule"
  default     = false
}

variable "check_eip_attached" {
  description = "Enable eip-attached rule"
  default     = false
}

variable "check_required_tags" {
  description = "Enable required-tags rule"
  default     = false
}

variable "required_tags_resource_types" {
  description = "Resource types to check for tags."
  type        = list(string)
  default     = []
}

variable "required_tags" {
  description = "A map of required resource tags. Format is tagNKey, tagNValue, where N is int. Values are optional."
  type        = map(string)
  default     = {}
}

variable "check_instances_in_vpc" {
  description = "Enable instances-in-vpc rule"
  default     = false
}

variable "check_acm_certificate_expiration_check" {
  description = "Enable acm-certificate-expiration-check rule"
  default     = false
}

variable "check_iam_password_policy" {
  description = "Enable iam-password-policy rule"
  default     = false
}

variable "check_iam_group_has_users_check" {
  description = "Enable iam-group-has-users-check rule"
  default     = false
}

variable "check_iam_user_no_policies_check" {
  description = "Enable iam-user-no-policies-check rule"
  default     = false
}

variable "check_ec2_volume_inuse_check" {
  description = "Enable ec2-volume-inuse-check rule"
  default     = false
}

variable "check_approved_amis_by_tag" {
  description = "Enable approved-amis-by-tag rule"
  default     = false
}

variable "ami_required_tag_key_value" {
  description = "Tag/s key and value which AMI has to have in order to be compliant: Example: key1:value1,key2:value2"
  type        = string
  default     = ""
}

variable "check_ec2_encrypted_volumes" {
  description = "Enable ec2-encrypted-volumes rule"
  default     = false
}

variable "check_rds_storage_encrypted" {
  description = "Enable rds-storage-encrypted rule"
  default     = false
}

variable "check_rds_snapshots_public_prohibited" {
  description = "Enable rds-snapshots-public-prohibited rule"
  default     = false
}

variable "check_s3_bucket_public_write_prohibited" {
  description = "Enable s3-bucket-public-write-prohibited rule"
  default     = false
}
