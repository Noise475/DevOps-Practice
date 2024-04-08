# modules/iam/main.tf

# SSO configuration for AWS access

data "aws_ssoadmin_instances" "example" {}

# resource "aws_ssoadmin_account_assignment" "example" {
#   instance_arn       = var.sso_instance_arn
#   permission_set_arn = var.permission_set_arn

#   principal_id   = var.sso_group_id
#   principal_type = "GROUP"

#   target_id   = var.account_id
#   target_type = "AWS_ACCOUNT"
# }
