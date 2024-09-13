# Create Cluster and Node roles
resource "aws_iam_role" "cluster_role" {
  name = "${var.environment}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      },
      {
        Effect = "Allow"
        Principal = {
          AWS = "${var.role_arn}"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role" "eks_node_instance_role" {
  name = "${var.environment}-eksNodeInstanceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
      {
        Effect = "Allow"
        Principal = {
          AWS = "${var.role_arn}"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Create Policies
resource "aws_iam_policy" "cluster_policy" {
  name        = "${var.environment}-eks-cluster-policy"
  description = "Policy for ${var.environment} EKS Cluster"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeRouteTables",
          "ec2:DescribeVpcs",
          "ec2:DescribeAutoScalingGroups",
          "ec2:DescribeLaunchConfigurations",
          "ec2:DescribeScalingActivities",
          "ec2:DescribeTags"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "elasticloadbalancing:Describe*"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "cloudwatch:DescribeAlarms",
          "cloudwatch:GetMetricData",
          "cloudwatch:ListMetrics",
          "cloudwatch:GetMetricStatistics"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "iam:ListAttachedRolePolicies",
          "iam:GetRole"

        ],
        Resource = "arn:aws:iam::${var.account_id}:role/${var.environment}-cluster-role"
      }
    ]

  })

  tags = var.tags
}

resource "aws_iam_policy" "eks_node_policy" {
  name        = "${var.environment}-eks-node-policy"
  description = "Allow specific actions on EC2 and IAM resources"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:UpdateAutoScalingGroup",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:DescribeScalingActivities",
          "ec2:RunInstances",
          "ec2:ModifyInstanceAttribute",
          "ec2:DescribeInstances",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeRouteTables",
          "ec2:DescribeVpcs",
          "ec2:DescribeTags",
          "ec2:DescribeNetworkInterfaces",
          "ec2:AttachNetworkInterface",
          "ec2:DetachNetworkInterface",
          "ec2:ModifyNetworkInterfaceAttribute",
          "ec2:DeleteNetworkInterface",
          "ec2:CreateNetworkInterface",
          "ec2:AssignPrivateIpAddresses",
          "ec2:UnassignPrivateIpAddresses",
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:DeregisterTargets",
          "elasticloadbalancing:DescribeTargetGroups"
        ],
        Resource = [
          "*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "eks:*"
        ],
        Resource = "${aws_eks_cluster.terragrunt_cluster["${var.environment}"].arn}"
      }
    ]
  })

  tags = var.tags
}

# Attach policies to cluster_role
resource "aws_iam_role_policy_attachment" "cluster_role_attachment" {
  role       = aws_iam_role.cluster_role.name
  policy_arn = aws_iam_policy.cluster_policy.arn
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {
  for_each = toset([
    "AmazonEKSClusterPolicy",
    "AmazonEKSServicePolicy"
  ])

  role       = aws_iam_role.cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/${each.value}"
}

# Attach policies to node_role
resource "aws_iam_policy_attachment" "eks_node_policy_attachment" {
  name       = "${var.environment}-eks-node-policy-attachment"
  roles      = [aws_iam_role.eks_node_instance_role.name]
  policy_arn = aws_iam_policy.eks_node_policy.arn
}

resource "aws_iam_role_policy_attachment" "eks_worker_policies" {
  for_each = toset([
    "AmazonEKSWorkerNodePolicy",
    "AmazonEC2ContainerRegistryReadOnly",
    "AmazonEKS_CNI_Policy",
    "CloudWatchLogsFullAccess",
    "AmazonSSMManagedInstanceCore"
  ])

  policy_arn = "arn:aws:iam::aws:policy/${each.value}"
  role       = aws_iam_role.eks_node_instance_role.name
}
