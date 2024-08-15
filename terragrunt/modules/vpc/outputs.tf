# modules/vpc/outputs.tf

output "vpc_id" {
  value = aws_vpc.eks_vpc.id
}

output "public_subnet_ids" {
  value = [for subnet in aws_subnet.public_subnets : subnet.id]
}


output "private_subnet_ids" {
  value = [for subnet in aws_subnet.private_subnets : subnet.id]
}
