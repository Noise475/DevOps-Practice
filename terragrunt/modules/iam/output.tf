output "ou_role_arns" {
  value = { for env in var.environments : env => aws_iam_role.ou_role[env].arn }
}

output "ou_role_arn" {
  value = aws_iam_role.ou_role[var.environment].arn
}


output "tf_role_arn" {
  value = aws_iam_role.terraform_role.arn
}