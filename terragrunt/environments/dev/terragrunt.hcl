# environments/dev/terragrunt.hcl
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket         = "dev-remote-state-terraform-bucket"
    region         = "us-east-2"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    encrypt        = true
    dynamodb_table = "dev-terraform-lock-table"
  }
}

# Terraform code source location
terraform {
  source = "../../modules" #"git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules?ref=0.0.0"
}

# Load these modules first
dependencies {
  paths = ["../../modules/kms", "../../modules/vpc", "../../modules/s3", "../../modules/dynamodb"]
}

include "kms" {
  path = "../../modules/kms"
}

include "vpc" {
  path = "../../modules/vpc"
}

include "s3" {
  path = "../../modules/s3"
}

include "dynamodb" {
  path = "../../modules/dynamodb"
}


# Vars to be replaced
inputs = {
  environment = "dev"
  region      = "us-east-2"
}

# Include the root terragrunt.hcl for any additional configurations
include "root" {
  path = find_in_parent_folders()
}
