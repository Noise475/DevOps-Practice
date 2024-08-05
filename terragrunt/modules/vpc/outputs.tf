# modules/vpc/outputs.tf

output "vpc_id" {
  value = aws_vpc.eks_vpc.id
}

output "subnets" {
  value = [ aws_subnet.eks_subnet_a.id,
    aws_subnet.eks_subnet_b.id,
    aws_subnet.eks_subnet_c.id,
    aws_subnet.eks_private_subnet_a.id,
    aws_subnet.eks_private_subnet_b.id,
    aws_subnet.eks_private_subnet_c.id
  ]
}
