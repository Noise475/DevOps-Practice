# modules/ou_creation/main.tf

# Create Organizational Units
resource "aws_organizations_organizational_unit" "ou" {
  count     = length(var.ou_names)
  name      = var.ou_names[count.index].name
  parent_id = length(data.aws_organizations_organization.current.roots) > 0 ? data.aws_organizations_organization.current.roots[0].id : null

}
