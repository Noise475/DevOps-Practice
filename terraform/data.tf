# Use all availability zones in region

data "aws_availability_zones" "all" {}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "image-id"
    values = ["ami-0f7919c33c90f5b58"]
  }

}