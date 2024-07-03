# modules/vpc/main.tf

# VPC
resource "aws_vpc" "eks_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = var.tags
}

# Internet Gateway for Public Subnets
resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = var.tags
}

# Route Table for Public Subnets
resource "aws_route_table" "eks_public_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = var.tags
}

resource "aws_route_table_association" "eks_subnet_a_association" {
  subnet_id      = aws_subnet.eks_subnet_a.id
  route_table_id = aws_route_table.eks_public_rt.id
}

resource "aws_route_table_association" "eks_subnet_b_association" {
  subnet_id      = aws_subnet.eks_subnet_b.id
  route_table_id = aws_route_table.eks_public_rt.id
}

resource "aws_route_table_association" "eks_subnet_c_association" {
  subnet_id      = aws_subnet.eks_subnet_c.id
  route_table_id = aws_route_table.eks_public_rt.id
}

# Public Subnets
resource "aws_subnet" "eks_subnet_a" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true

  tags = var.tags
}

resource "aws_subnet" "eks_subnet_b" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = true

  tags = var.tags
}

resource "aws_subnet" "eks_subnet_c" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-2c"
  map_public_ip_on_launch = true

  tags = var.tags
}

# Private Subnets
resource "aws_subnet" "eks_private_subnet_a" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-2a"

  tags = var.tags
}

resource "aws_subnet" "eks_private_subnet_b" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-east-2b"

  tags = var.tags
}

resource "aws_subnet" "eks_private_subnet_c" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "us-east-2c"

  tags = var.tags
}

# Route Table for Private Subnets
resource "aws_route_table" "eks_private_rt_a" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = var.tags
}

resource "aws_route_table" "eks_private_rt_b" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = var.tags
}

resource "aws_route_table" "eks_private_rt_c" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = var.tags
}

# Routes For Private Subnets
resource "aws_route" "eks_private_rt_a" {
  route_table_id         = aws_route_table.eks_private_rt_a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.eks_nat_gateway_a.id
}

resource "aws_route" "eks_private_rt_b" {
  route_table_id         = aws_route_table.eks_private_rt_b.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.eks_nat_gateway_b.id

}

resource "aws_route" "eks_private_rt_c" {
  route_table_id         = aws_route_table.eks_private_rt_c.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.eks_nat_gateway_c.id
}

# Security Groups
resource "aws_security_group" "eks_cluster_sg" {
  name        = "eks-cluster-sg"
  description = "Security group for EKS cluster"
  vpc_id      = aws_vpc.eks_vpc.id

  tags = var.tags
}
