# moduels/ou_creation/outputs.tf


# List of ids for organizational units
output "ou_ids" {
  value = aws_organizations_organizational_unit.ou[*].id
}

# role arn for organzational unit role
locals {
  ou_role_arns = [for role_key in keys(aws_iam_role.ou_roles) : aws_iam_role.ou_roles[role_key].arn]
}

output "ou_role_arn" {
  value = local.ou_role_arns
}
