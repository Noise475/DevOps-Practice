# terragrunt.hcl
iam_role = "arn:aws:iam::503489311732:role/terragrunt"

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket         = "global-remote-state-terraform-bucket"
    region         = "us-east-2"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    encrypt        = true
    dynamodb_table = "terraform-state-lock-table"
  }
}

generate "provider" {
  path      = "provider_override.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "us-east-2"
  assume_role {
    role_arn = "arn:aws:iam::503489311732:role/terragrunt"
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
