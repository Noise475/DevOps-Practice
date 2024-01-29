# modules/ou_creation/data.tf

# Define a data source to get information about the AWS organization
data "aws_organizations_organization" "current" {}
