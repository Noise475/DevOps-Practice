# environments/dev/terragrunt.hcl

remote_state {
  backend = "s3"
  config = {
    bucket         = "terraform-state-bucket"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "dynamodb-lock-table"
  }
}

# The URL used here is a shorthand for
# "tfr://registry.terraform.io/terraform-aws-modules/vpc/aws?version=3.5.0".
# Note the extra `/` after the protocol is required for the shorthand
# notation.
terraform {
  source = "git::git@github.com:Noise475/DevOps-Practice.git?ref=0.0.1"
}

# Include VPC module
include {
  path = "../../modules/vpc"
}

# Include EKS module
include {
  path = "../../modules/eks"
}

# Include DynamoDB module
include {
  path = "../../modules/dynamodb"
}

# Include S3 module
include {
  path = "../../modules/s3"
}


# Indicate what region to deploy the resources into
generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = "us-east-2"
}
EOF
}

# Indicate the input values to use for the variables of the module.
inputs = {

  tags = {
    Terraform = "true"
  }
}
