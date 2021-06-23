
variable "config_logs_bucket" {
  default = ""
}

variable "config_name" {
  default = ""
}

variable "config_tags" {
  default = {}
}

variable "s3_log_prefix" {
  default = ""
}

variable "sns_topic_arn" {
  description = "The ARN of topic."
  default     = ""
}

variable "config_delivery_frequency" {
  description = "The frequency with which AWS Config delivers configuration snapshots."
  default     = "Six_Hours"
}
variable "account_role_name" {
  description = "Role for network account"
  default = "AWSLZCoreOUAdminRole"
}

/*

variable "account_id" {
  description = "Account ID"
  default = ""
}*/