# environments/dev/terragrunt.hcl
dependency "iam" {
  config_path = "../../iam"
  mock_outputs = {
    ou_role_arn = "placeholder"
  }
}

# Generate provider.tf configuration dynamically
generate "provider" {
  path      = "provider_override.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${get_env("REGION")}"
  assume_role {
    role_arn = "${dependency.iam.outputs.ou_role_arn}"
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
    bucket         = "dev-remote-state-terraform-bucket"
    region         = "${get_env("REGION")}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    encrypt        = true
    dynamodb_table = "dev-terraform-lock-table"
  }
}

include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../..//modules" #"git::git@github.com:Noise475/DevOps-Practice.git/terragrunt//modules`?ref=0.0.0"
}

inputs = {
  environment = "dev"
  region      = "${get_env("REGION")}"
}
