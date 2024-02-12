# modules/ou_creation/main.tf

# Create Organizational Units
resource "aws_organizations_organizational_unit" "ou" {
  count     = length(var.ou_names)
  name      = var.ou_names[count.index].name
  parent_id = length(data.aws_organizations_organization.current.roots) > 0 ? data.aws_organizations_organization.current.roots[0].id : null

}

# Iterate over the list of OUs and create IAM roles
resource "aws_iam_role" "ou_roles" {
  for_each           = { for ou in var.ou_names : ou.name => ou }
  name               = "OU-${each.value.name}-Role"
  assume_role_policy = file("./policies/ou-role.json")
}

# Define policies for each OU
resource "aws_iam_policy" "ou_policies" {
  for_each = aws_iam_role.ou_roles

  name        = "OU-${each.key}-Policy"
  description = "Policy for ${each.key}"

  # Define policy document here
  policy = file("./policies/env-perms.json")
}

# Attach policies to roles
resource "aws_iam_policy_attachment" "ou_policy_attachments" {
  for_each = aws_iam_role.ou_roles

  name       = "OU-${each.key}-Policy-Attachment"
  roles      = [aws_iam_role.ou_roles[each.key].name]
  policy_arn = aws_iam_policy.ou_policies[each.key].arn
}
