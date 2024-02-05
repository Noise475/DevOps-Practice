# terragrunt.hcl
iam_role = "arn:aws:iam::503489311732:role/terragrunt"

terraform {
  source =  "./modules" #"git::git@github.com:Noise475/DevOps-Practice.git/terragrunt//modules`?ref=0.0.0"
}

locals {
  region = env("AWS_REGION", "us-east-2")
  environment = env("ENVIRONMENT", "dev")
  role_arn = env("ROLE_ARN", iam_role)
}


remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket         = "${local.environment}-remote-state-terraform-bucket"
    region         = "${local.region}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    encrypt        = true
    dynamodb_table = "${local.environment}-terraform-lock-table"
  }
}

generate "provider" {
  path      = "provider.tf"
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

# Include the input values to use for the variables of the module.
inputs = {
  tags = {
    Terraform = "true"
  }
}
