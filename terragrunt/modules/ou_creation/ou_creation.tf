# modules/ou_creation/main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Create Organizational Units
resource "aws_organizations_organizational_unit" "ou" {
  for_each = var.ou_names

  name      = var.ou_names[each.value]
  parent_id = length(data.aws_organizations_organization.current.roots) > 0 ? data.aws_organizations_organization.current.roots[0].id : null

  tags = merge(var.tags, { Environment = var.ou_names[each.value] })
}

data "aws_organizations_organization" "current" {}
