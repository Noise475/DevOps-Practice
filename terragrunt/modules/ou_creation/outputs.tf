# moduels/ou_creation/outputs.tf

output "ou_ids" {
  description = "List of IDs of the created OUs"
  value       = aws_organizations_organizational_unit.ou[*].id
}