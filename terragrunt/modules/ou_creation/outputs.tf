# moduels/ou_creation/outputs.tf

# List of ids for organizational units
output "ou_ids" {
  value = aws_organizations_organizational_unit.ou[*].id
}
