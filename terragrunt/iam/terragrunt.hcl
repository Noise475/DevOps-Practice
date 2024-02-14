# terragrunt/ou_creation/terragrunt.hcl

terraform {
  source = "../modules/iam" #"git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules/iam?ref=0.0.0"
}

include "root" {
  path = find_in_parent_folders()
}

# Generate provider configuration dynamically
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

inputs = {
  environment = basename(find_in_parent_folders())
  region = "us-east-2"
}
