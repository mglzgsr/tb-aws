
variable "bucket_name" {
  type    = string
  default = ""
}

variable "config_tags" {
  default = {}
}

variable "versioning_enabled" {
  description = "Set versioning in S3 bucket"
  type        = bool
  default     = true
}

variable "acl_access_bucket" {
  description = "ACL value for Access Bucket"
  default     = "log-delivery-write"
}

variable "kms_key" {
  description = "KMS Key"
  default     = ""
}

variable "enc_algorithm" {
  default = "aws:kms"
}
