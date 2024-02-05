# moduels/ou_creation/outputs.tf

# List of ids for organizational units
output "ou_ids" {
  value = aws_organizations_organizational_unit.ou[*].id
}

# role arn for organzational unit role
output "ou_role_arn" {
  value = aws_iam_role.ou_roles[*].arn
}
