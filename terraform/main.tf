# Provider information and cloud deployment region

provider "aws" {
  region = "us-east-2"
  shared_credentials_file = var.creds
}

