# modules/iam/sso.tf

# SSO configuration for AWS access
resource "aws_iam_role" "sso_assumable_role" {
  name = "sso_assumable_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/AWSReservedSSO_YourPermissionSetName_*"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    OrgID     = var.environment
    Terraform = "true"
  }
}

resource "aws_iam_role_policy_attachment" "sso_assumable_role_policy" {
  role       = aws_iam_role.sso_assumable_role.name
  policy_arn = "arn:aws:iam::aws:policy/YourPolicyArn"
}

data "aws_caller_identity" "current" {}


resource "aws_iam_ssoadmin_permission_set" "assume_role_permission_set" {
  instance_arn = data.aws_ssoadmin_instances.main.arn
  name         = "AssumeTerraformRolePermissionSet"

  tags = {
    OrgID     = var.environment
    Terraform = "true"
  }

  inline_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : "sts:AssumeRole",
        Resource : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/terraform_role"
      }
    ]
  })
}

data "aws_ssoadmin_instances" "main" {}
