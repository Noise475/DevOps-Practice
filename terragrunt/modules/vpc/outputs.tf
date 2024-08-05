# modules/vpc/outputs.tf

output "vpc_id" {
  value = aws_vpc.eks_vpc.id
}

output "public_subnet_ids" {
  value = [aws_subnet.public_subnets[*]]
}

output "private_subnet_ids" {
  value = [aws_subnet.private_subnets[*]]
}
