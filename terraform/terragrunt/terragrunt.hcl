remote_state {
  backend = "s3"
  config = {
    bucket         = "terraform-state-bucket"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "terraform-state-lock-table"
    access_key     = ""
    secret_key     = "" 
  }
}

# Common variables across modules
locals {
  region = "us-east-2"
}

#VPC
include {
  path = "./modules/vpc"
}

#EKS
include {
  path = "./modules/eks"
}

