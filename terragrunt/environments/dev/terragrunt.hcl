# environments/dev/terragrunt.hcl

# Generate provider.tf configuration dynamically
generate "provider" {
  path      = "provider_override.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${get_env("REGION")}"
}
EOF
}

# Generate backend.tf
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket         = "dev-remote-state-terraform-bucket"
    region         = "${get_env("REGION")}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    encrypt        = true
    dynamodb_table = "dev-terraform-lock-table"
  }
}

# Generate Dev IAM Policy
generate "iam_policy" {
  path = "${get_parent_terragrunt_dir()}/../../modules/iam/ou-terraform-policy.json"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:*",
                "iam:AttachRolePolicy",
                "iam:AttachUserPolicy",
                "iam:CreateGroup",
                "iam:CreatePolicy",
                "iam:CreatePolicyVersion",
                "iam:CreateRole",
                "iam:DeletePolicy",
                "iam:DeletePolicyVersion",
                "iam:DetachRolePolicy",
                "iam:GetPolicy",
                "iam:GetPolicyVersion",
                "iam:GetRole",
                "iam:ListAttachedRolePolicies",
                "iam:ListEntitiesForPolicy",
                "iam:ListPolicyVersions",
                "iam:ListRolePolicies",
                "iam:PassRole",
                "iam:PutRolePolicy",
                "iam:PutUserPolicy",
                "iam:UpdateAssumeRolePolicy",
                "iam:TagRole",
                "kms:Create*",
                "kms:Describe*",
                "kms:Enable*",
                "kms:List*",
                "kms:Put*",
                "kms:Update*",
                "kms:Revoke*",
                "kms:Disable*",
                "kms:Get*",
                "kms:Delete*",
                "kms:ScheduleKeyDeletion",
                "kms:CancelKeyDeletion",
                "organizations:Describe*",
                "organizations:List*",
                "s3:*",
                "ssm:*",
                "sso:ListInstances",
                "sso:ListAccountAssignments",
                "dynamodb:*",
                "vpc:*"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "aws:RequestTag/OrgID": "dev"
                }
            }
        }
    ]
}
EOF
}


terraform {
  source = "../..//modules" #"git::git@github.com:Noise475/DevOps-Practice.git/terragrunt//modules`?ref=0.0.0"
}

inputs = {
  environment = "dev"
  region      = "${get_env("REGION")}"
  role_arn    = "${get_env("ROLE_ARN")}"
  account_id  = "${get_env("ACCOUNT_ID")}"
  tags = {
    OrgID     = "dev"
    Terraform = "true"
  }
}
