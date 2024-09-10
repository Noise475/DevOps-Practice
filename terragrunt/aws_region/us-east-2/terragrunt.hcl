# us-east-2/terragrunt.hcl

terraform {
  source = "git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules?ref=0.0.1"
}

locals {
  region     = "us-east-2"
  table_name = "root-terraform-lock-table"
}

# Generate provider configuration dynamically
generate "provider" {
  path      = "provider_override.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region}"
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
    key            = "${path_relative_to_include()}/terraform.tfstate"
    encrypt        = true
    dynamodb_table = "${local.table_name}"
  }
}

# Include the input values to use for the variables of the module.
inputs = {
  account_id = "${get_env("ACCOUNT_ID")}"
  region     = "${local.region}"
  table_name = "${local.table_name}"

  tags = {
    Terraform = "true"
    Region    = "${local.region}"
  }
}
