# environments/dev/backend.tf

terraform {
  backend "s3" {
    bucket         = "global-remote-state-terraform-bucket"
    region         = "us-east-2"
    key            = "dev/terraform.tfstate" # This key should be manually updated per environment
    encrypt        = true
    dynamodb_table = "terraform-state-lock-table"
  }
}
