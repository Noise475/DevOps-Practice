# us-east-2/environments/staging/terragrunt.hcl

terraform {
  source = "git::https://github.com/Noise475/DevOps-Practice.git//terragrunt/modules?ref=0.0.4"
}

locals {
  region = "us-east-2"
}

# Generate provider configuration dynamically
generate "provider" {
  path      = "provider_override.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = ${local.region}
  assume_role {
    role_arn = "${get_env("ROLE_ARN")}"
  }
}
EOF
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket         = "root-remote-state-tf-bucket"
    region         = ${local.region}
    key            = "${path_relative_to_include()}/terraform.tfstate"
    encrypt        = true
    dynamodb_table = "staging-terraform-lock-table"
  }
}

inputs = {
  environment  = "staging"
  environments = ["staging"]
  region       = ${local.region}
  role_arn     = "arn:aws:iam::590183659157:role/staging"
  account_id   = "${get_env("ACCOUNT_ID")}"

  tags = {
    Org_ID      = "${get_env("ORG_ID")}"
    environment = "staging"
    Terraform   = "true"
    Region      = ${local.region}
  }
}
