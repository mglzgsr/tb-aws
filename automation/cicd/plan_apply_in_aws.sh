<<<<<<< HEAD
#!/bin/bash 
# Variables 

export AWS_ACCESS_KEY_ID=${access_key}
export AWS_SECRET_ACCESS_KEY=${secret_key}
export AWS_DEFAULT_REGION=${DEV_region}

# Paths 
MAIN_PATH=$(pwd)
AUTOMATION_SCRIPTS="${MAIN_PATH}/automation/cicd"
TERRAFORM_PATH="${MAIN_PATH}/terraform"

cd ${TERRAFORM_PATH}
 
echo "------------------------TERRAFORM INIT--------------------------------------------"
terraform init
echo "------------------------TERRAFORM APPLY-------------------------------------------"
#TF_LOG=DEBUG terraform apply -refresh=true -auto-approve
#terraform apply -auto-approve

#This scripts generates the Guardduty instances in all accounts and all regions
#python3 ${AUTOMATION_SCRIPTS}/guardduty.py

terraform state rm module.aws_lz_config_service.aws_sns_topic_policy.sns_default_policy
#terraform state rm module.aws_lz_config_bucket.aws_s3_bucket.s3_main
#terraform state rm module.aws_lz_config_bucket.aws_s3_bucket.s3_log

#terraform state rm module.aws_lz_guardduty_bucket.aws_s3_bucket.s3_findings
#terraform state rm module.aws_s3_bucket_policy_logarchive.aws_s3_bucket.s3_findings
=======
#!/bin/bash 
# Variables 

export AWS_ACCESS_KEY_ID=${access_key}
export AWS_SECRET_ACCESS_KEY=${secret_key}
export AWS_DEFAULT_REGION=${DEV_region}

# Paths 
MAIN_PATH=$(pwd)
AUTOMATION_SCRIPTS="${MAIN_PATH}/automation/cicd"
TERRAFORM_PATH="${MAIN_PATH}/terraform"

cd ${TERRAFORM_PATH}
 
echo "------------------------TERRAFORM INIT--------------------------------------------"
terraform init
echo "------------------------TERRAFORM APPLY-------------------------------------------"
#TF_LOG=DEBUG terraform apply -refresh=true -auto-approve
terraform apply -auto-approve

#This scripts generates the Guardduty instances in all accounts and all regions
#python3 ${AUTOMATION_SCRIPTS}/guardduty.py

#terraform state rm module.aws_lz_config_service.aws_sns_topic_policy.sns_default_policy
#terraform state rm module.aws_lz_config_bucket.aws_s3_bucket.s3_main
#terraform state rm module.aws_lz_config_bucket.aws_s3_bucket.s3_log

#terraform state rm module.aws_lz_guardduty_bucket.aws_s3_bucket.s3_findings
#terraform state rm module.aws_s3_bucket_policy_logarchive.aws_s3_bucket.s3_findings

#terraform state rm module.aws_lz_config_service.aws_config_configuration_recorder_status.main
#terraform state rm module.aws_lz_config_service.aws_config_configuration_recorder.main
>>>>>>> 74283475571aa39e4f4f6e665beb84f4f6e828ff
