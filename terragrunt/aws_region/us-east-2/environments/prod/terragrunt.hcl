# us-east-2/environments/prod/terragrunt.hcl

terraform {
  source = "git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules?ref=0.0.0"
}

locals {
  region   = "us-east-2"
  role_arn = "arn:aws:iam::590183659157:role/prod"
}

# Generate provider configuration dynamically
generate "provider" {
  path      = "provider_override.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region}"
  assume_role {
    role_arn = "${local.role_arn}"
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
    bucket         = "root-remote-state-tf-bucket"
    region         = "${local.region}"
    key            = "${path_relative_to_include()}/environments/prod/terraform.tfstate"
    encrypt        = true
    dynamodb_table = "prod-terraform-lock-table"
  }
}

inputs = {
  environment  = "prod"
  environments = ["prod"]
  region       = "${local.region}"
  role_arn     = "${local.role_arn}"
  account_id   = "${get_env("ACCOUNT_ID")}"
  org_id       = "ou-5cu4-8jqd6a78" # Get from ou_creation outputs

  tags = {
    Org_ID      = "ou-5cu4-8jqd6a78" # Get from ou_creation outputs
    Environment = "prod"
    Terraform   = "true"
    Region      = "${local.region}"
  }
}
