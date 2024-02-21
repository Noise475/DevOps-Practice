# moduels/ou_creation/outputs.tf

# List of ids for organizational units
output "ou_ids" {
  value = aws_organizations_organizational_unit.ou[*].id
}

output "ou_names" {
  value = aws_organizations_organizational_unit.ou[*].name
}

output "current_ou_id" {
  value = lookup(
    { for idx, name in aws_organizations_organizational_unit.ou[*].name : name => aws_organizations_organizational_unit.ou[idx].id },
    var.environment
  )
}
