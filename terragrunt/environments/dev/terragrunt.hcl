# environments/dev/terragrunt.hcl

terraform {
  source = "git::https://github.com/Noise475/DevOps-Practice.git//terragrunt/modules?ref=0.0.1"
}

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
    bucket         = "dev-remote-state-tf-bucket"
    region         = "${get_env("REGION")}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    encrypt        = true
    dynamodb_table = "dev-terraform-lock-table"
  }
}

locals {
  tags = {
    OrgID       = "dev"
    Environment = "dev"
    Terraform   = "true"
  }
}

inputs = {
  environment = "dev"
  region      = "${get_env("REGION")}"
  role_arn    = "${get_env("ROLE_ARN")}"
  account_id  = "${get_env("ACCOUNT_ID")}"

  tags = {
    OrgID       = "dev"
    Environment = "dev"
    Terraform   = "true"
  }
}
