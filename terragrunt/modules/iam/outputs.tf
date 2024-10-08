output "ou_role_arns" {
  value = { for env in var.environments : env => aws_iam_role.ou_role[env].arn }
}

output "tf_role_arn" {
  value = aws_iam_role.terraform_role.arn
}

output "sso_instance_arn" {
  value = tolist(data.aws_ssoadmin_instances.main.arns)[0]
}

output "sso_group_id" {
  value = data.aws_identitystore_group.main.group_id
}

output "permission_set_arn" {
  value = aws_ssoadmin_permission_set.assume_tf_role_permission_set.arn
}

output "gh_role_arn" {
  value = aws_iam_role.github_oidc_role.arn
}

output "account_id" {
  value = var.account_id
}

output "environments" {
  value = var.environments
}

output "org_ids" {
  value = var.org_ids
}
