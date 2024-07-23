provider "aws" {
  region = "us-east-2"
  assume_role {
    role_arn = "${get_env("ROLE_ARN")}"
  }
}
