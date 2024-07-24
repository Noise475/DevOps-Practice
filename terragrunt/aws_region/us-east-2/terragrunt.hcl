# environments/dev/ssm/terragrunt.hcl

terraform {
  source = "git::https://github.com/Noise475/DevOps-Practice.git//terragrunt/modules?ref=0.0.3"
}

# Generate provider configuration dynamically
generate "provider" {
  path      = "provider_override.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "us-east-2"
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
    region         = "us-east-2"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    encrypt        = true
    dynamodb_table = "root-terraform-lock-table"
  }
}

# Include the input values to use for the variables of the module.
inputs = {
  region     = "us-east-2"
  role_arn   = "${get_env("ROLE_ARN")}"
  account_id = "${get_env("ACCOUNT_ID")}"

  tags = {
    Terraform = "true"
  }
}
