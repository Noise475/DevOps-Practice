# environments/prod/terragrunt.hcl

# Loop over the list of OUs and create IAM roles and policies dynamically
foreach = {
  ou in var.ou
}

include "iam_roles" {
  path = "${ou}/iam_roles.hcl"
}

# Generate provider configuration dynamically
generate "provider" {
  path      = "provider_override.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "us-east-2"
  assume_role {
    role_arn = var.provider_role_arn
  }
}
EOF

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket         = "prod-remote-state-terraform-bucket"
    region         = "us-east-2"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    encrypt        = true
    dynamodb_table = "prod-terraform-lock-table"
  }
}

terraform {
  source = "../..//modules" #"git::git@github.com:Noise475/DevOps-Practice.git/terragrunt//modules`?ref=0.0.0"
}

# Vars to be replaced
inputs = {
  environment = "prod"
  region      = "us-east-2"
}
