# Define IAM role for the staging OU
resource "aws_iam_role" "ou_role" {
  name               = var.ou_role
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attach policies to the IAM role
resource "aws_iam_policy_attachment" "staging_policy_attachment" {
  name       = "staging-policy-attachment"
  roles      = [aws_iam_role.staging_role.name]
  policy_arn = "arn:aws:iam::aws:policy/YourPolicyName"  # Replace with the ARN of the OU-specific policy
}
