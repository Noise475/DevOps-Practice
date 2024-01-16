# environments/staging/terragrunt.hcl

terraform {
  source = "../..//modules" #"git::git@github.com:Noise475/DevOps-Practice.git//?ref=0.0.1"
}

dependencies {
  paths = ["../..//modules/vpc", "../..//modules/kms", "../..//modules/s3/"]
}

include "root" {
  path = find_in_parent_folders()
}

# Include VPC module
include "vpc" {
  path = "../../modules//vpc"
}

# Include EKS module
include "eks" {
  path = "../../modules//eks"
}

# Include DynamoDB module
include "dynamodb" {
  path = "../../modules//dynamodb"
}

# Include S3 module
include "s3" {
  path = "../../modules//s3"
}


hooks {
  before_all = ["bash generate_docs.sh"]
}

inputs = {
  environment = "staging"
}
