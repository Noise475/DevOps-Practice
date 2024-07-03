# modules/iam/sso.tf

# SSO configuration for AWS access
data "aws_caller_identity" "current" {}

data "aws_ssoadmin_instances" "main" {}

data "aws_identitystore_group" "main" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.main.identity_store_ids)[0]

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = "DevOps"
    }
  }
}

resource "aws_ssoadmin_permission_set" "assume_tf_role_permission_set" {
  description      = "Assume terraform_role permission"
  instance_arn     = tolist(data.aws_ssoadmin_instances.main.arns)[0]
  relay_state      = "https://s3.console.aws.amazon.com/s3/home?region=us-east-2#"
  session_duration = "PT8H"
  name             = "AssumeTerraformRolePermissionSet"

  tags = var.tags
}

resource "aws_ssoadmin_permission_set_inline_policy" "assume_tf_role_permission_set_policy" {
  inline_policy = templatefile("${path.module}/policies/assume-tf-permission-set.json", {
    account_id  = var.account_id
  })
  instance_arn       = tolist(data.aws_ssoadmin_instances.main.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.assume_tf_role_permission_set.arn
}

resource "aws_ssoadmin_account_assignment" "devops_group_assignment" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.main.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.assume_tf_role_permission_set.arn

  principal_id   = data.aws_identitystore_group.main.group_id
  principal_type = "GROUP"

  target_id   = data.aws_caller_identity.current.account_id
  target_type = "AWS_ACCOUNT"
}
