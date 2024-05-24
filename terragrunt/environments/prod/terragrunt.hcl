# environments/prod/terragrunt.hcl

# Generate provider configuration dynamically
generate "provider" {
  path      = "provider_override.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${get_env("REGION")}"
  assume_role {
    role_arn = "${get_env("ROLE_ARN")}"
  }
}
EOF
}

# S3 remote_state store
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket         = "prod-remote-state-terraform-bucket"
    region         = "${get_env("REGION")}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    encrypt        = true
    dynamodb_table = "prod-terraform-lock-table"
  }
}

include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../..//modules" #"git::git@github.com:Noise475/DevOps-Practice.git/terragrunt//modules`?ref=0.0.0"
}

inputs = {
  environment = "prod"
  region      = "${get_env("REGION")}"
  role_arn    = "${get_env("ROLE_ARN")}"
  account_id  = "${get_env("ACCOUNT_ID")}"
  tags = {
    OrgID     = "prod"
    Terraform = "true"
  }
}

