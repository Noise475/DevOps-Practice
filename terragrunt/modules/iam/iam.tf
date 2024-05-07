# modules/iam/main.tf

#######################################################
# IAM Roles
#######################################################

# Define terraform_role for infrastructure administration
resource "aws_iam_role" "terraform_role" {
  name = "terraform_role"
  assume_role_policy = templatefile("./policies/assume-root-policy.json", {
    account_id = var.account_id
  })
  tags = {
    env = "root"
  }
}

# Define IAM role for the current OU
resource "aws_iam_role" "ou_role" {
  name = var.environment
  assume_role_policy = templatefile("./policies/assume-tf-policy.json", {
    account_id  = var.account_id
    environment = var.environment
  })

  tags = {
    env = "${var.environment}"
  }
}


#######################################################
# IAM Policies
#######################################################

# Define policies for terraform_role
resource "aws_iam_policy" "tf_policy" {
  name        = "root-terraform-policy"
  description = "administrative terraform policy for root"

  policy = file("./policies/root-terraform-policy.json")
}

# Define policies for OUs
resource "aws_iam_policy" "ou_tf_policy" {
  name        = "${var.environment}-terraform-policy"
  description = "administrative terraform policy for ${var.environment}"

  policy = templatefile("./policies/ou-terraform-policy.json", {
    environment = var.environment
  })
}

resource "aws_iam_policy" "ou_tf_state_policy" {
  name        = "${var.environment}-terraform-state-policy"
  description = "Terraform state policy for ${var.environment}"


  policy = templatefile("./policies/terraform-state-policy.json", {
    account_id  = var.account_id
    org_id      = var.org_id
    environment = var.environment
    region      = var.region
  })
}

resource "aws_iam_policy" "eks_policy" {
  name        = "eks-policy"
  description = "IAM policy for Amazon EKS"

  policy = templatefile("./policies/eks-policy.json", {
    environment = var.environment
  })
}

#######################################################
# IAM Policy Attachments
#######################################################

# Attach policies to terraform_role
resource "aws_iam_policy_attachment" "tf_policy_attachment" {
  name       = "${var.environment}-terraform-policy-attachment"
  roles      = [aws_iam_role.terraform_role.name]
  policy_arn = aws_iam_policy.tf_policy.arn
}

# Attach policies to ou_role
resource "aws_iam_policy_attachment" "ou_tf_policy_attachment" {
  name       = "${var.environment}-terraform-policy-attachment"
  roles      = [aws_iam_role.ou_role.name]
  policy_arn = aws_iam_policy.ou_tf_policy.arn
}

resource "aws_iam_policy_attachment" "ou_state_policy_attachment" {
  name       = "${var.environment}-terraform-state-policy-attachment"
  roles      = [aws_iam_role.ou_role.name, aws_iam_role.terraform_role.name]
  policy_arn = aws_iam_policy.ou_tf_state_policy.arn
}

resource "aws_iam_policy_attachment" "eks_policy_attachment" {
  name       = "${var.environment}-terraform-state-policy-attachment"
  roles      = [aws_iam_role.ou_role.name]
  policy_arn = aws_iam_policy.eks_policy.arn
}

