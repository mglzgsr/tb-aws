# Allow the AWS Config role to deliver logs to configured S3 Bucket.
# Derived from IAM Policy document found at https://docs.aws.amazon.com/config/latest/developerguide/s3-bucket-policy.html

data "template_file" "aws_config_policy" {
  template = <<JSON
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Sid": "AWSConfigBucketPermissionsCheck",
        "Effect": "Allow",
        "Action": "s3:GetBucketAcl",
        "Resource": "${var.bucket_log_arn}"
    },    
    {
        "Sid": "AWSConfigBucketDelivery",
        "Effect": "Allow",
        "Action": "s3:PutObject",
        "Resource": "$${resource}",
        "Condition": {
          "StringLike": {
            "s3:x-amz-acl": "bucket-owner-full-control"
          }
        }
    }
  ]
}
JSON

  vars = {    
    resource = format("%s/%s/AWSLogs/%s/Config/*",
                var.bucket_log_arn,
                var.config_logs_prefix,
                var.bucket_account_id)
  }
}

# Allow IAM policy to assume the role for AWS Config
data "aws_iam_policy_document" "aws_config_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com","cloudtrail.amazonaws.com"]
    }

    effect = "Allow"
  }
}

#
# IAM
#
resource "aws_iam_role" "main" {
  name               = var.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.aws_config_role_policy.json
  tags = var.config_tags
}

resource "aws_iam_policy_attachment" "iam_managed_policy_attachment" {
  name       = var.iam_managed_policy_attachment_name
  roles      = [aws_iam_role.main.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"  
}

resource "aws_iam_policy" "aws_config_policy" {
  name   = aws_iam_role.main.name
  policy = data.template_file.aws_config_policy.rendered  
}

resource "aws_iam_policy_attachment" "aws_config_policy" {
  name       = var.iam_policy_attachment_name
  roles      = [aws_iam_role.main.name]
  policy_arn = aws_iam_policy.aws_config_policy.arn
}

