# us-east-2/environments/dev/terragrunt.hcl

terraform {
  source = "git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules?ref=0.0.0"
}

locals {
  region   = "us-east-2"
  role_arn = "arn:aws:iam::590183659157:role/dev"
}

# Generate provider.tf configuration dynamically
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

# Generate backend.tf
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket         = "root-remote-state-tf-bucket"
    region         = "${local.region}"
    key            = "${path_relative_to_include()}/dev/terraform.tfstate"
    encrypt        = true
    dynamodb_table = "dev-terraform-lock-table"
  }
}

inputs = {
  environment  = "dev"
  environments = ["dev"]
  region       = "${local.region}"
  role_arn     = "${local.role_arn}"
  account_id   = "${get_env("ACCOUNT_ID")}"
  org_id       = "ou-5cu4-u75xvt41" # Get from ou_creation outputs

  tags = {
    Org_ID      = "ou-5cu4-u75xvt41" # Get from ou_creation outputs
    Environment = "dev"
    Terraform   = "true"
    Region      = "${local.region}"
  }
}
