# moduels/ou_creation/outputs.tf

# List of ids for organizational units
output "ou_ids" {
  value = {
    for i, ou in aws_organizations_organizational_unit.ou : var.ou_names[i] => ou.id
  }
}
