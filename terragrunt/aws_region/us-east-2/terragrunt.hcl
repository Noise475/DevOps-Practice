# environments/dev/ssm/terragrunt.hcl

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
    dynamodb_table = "root-terraform-lock-table"
  }
}

# Include the input values to use for the variables of the module.
inputs = {
  account_id           = "590183659157"
  environment          = "${get_env("ENVIRONMENT")}"
  environments         = ["dev", "staging", "prod"]
  region               = "${local.region}"
  role_arn             = "${get_env("ROLE_ARN")}"
  table_name           = "root-terraform-lock-table"


  tags = {
    Terraform = "true"
    Region    = local.region
  }
}
