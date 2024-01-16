# environments/dev/terragrunt.hcl
include "root" {
  path = find_in_parent_folders()
}

# Terraform code source location
terraform {
  source = "../../modules" #"git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules?ref=0.0.1"
}

# Load these modules first
dependencies {
  paths = ["../../modules/vpc", "../../modules/kms"]
}

# Include VPC module
include "vpc" {
  path = "../../modules/vpc"
}

# Include EKS module
include "eks" {
  path = "../../modules/eks"
}

# Include DynamoDB module
include "dynamodb" {
  path = "../../modules/dynamodb"
}

# Include S3 module
include "s3" {
  path = "../../modules/s3"
}

# Vars to be replaced
inputs = {
  environment = "dev"
}
