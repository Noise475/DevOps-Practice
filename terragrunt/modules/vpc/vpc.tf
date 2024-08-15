# modules/vpc/main.tf

# VPC
resource "aws_vpc" "eks_vpc" {
  cidr_block           = var.cidr_block
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

  tags = merge(var.tags, { Name = "public-rt-${var.environment}" })
}

resource "aws_route_table_association" "eks_subnet_a_association" {
  subnet_id      = aws_subnet.public_subnets["a"].id
  route_table_id = aws_route_table.eks_public_rt.id
}

resource "aws_route_table_association" "eks_subnet_b_association" {
  subnet_id      = aws_subnet.public_subnets["b"].id
  route_table_id = aws_route_table.eks_public_rt.id
}

resource "aws_route_table_association" "eks_subnet_c_association" {
  subnet_id      = aws_subnet.public_subnets["c"].id
  route_table_id = aws_route_table.eks_public_rt.id
}

# Public Subnets
resource "aws_subnet" "public_subnets" {
  for_each = { for sub, cidr in var.public_subnet_cidrs : sub => cidr }

  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = each.value
  availability_zone       = var.availability_zones[each.key]
  map_public_ip_on_launch = true

  tags = var.tags
}

# Private Subnets
resource "aws_subnet" "private_subnets" {
  for_each = { for sub, cidr in var.private_subnet_cidrs : sub => cidr }

  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = each.value
  availability_zone = var.availability_zones[each.key]

  tags = var.tags
}

# Route Tables for Private Subnets
resource "aws_route_table" "eks_private_rt" {
  for_each = toset(["a", "b", "c"])

  vpc_id = aws_vpc.eks_vpc.id

  tags = merge(var.tags, {
    Name = "private-rt-${each.key}-${var.environment}"
  })
}

# Routes For Private Subnets
resource "aws_route" "eks_private_rt" {
  for_each = {
    "a" = aws_route_table.eks_private_rt["a"].id
    "b" = aws_route_table.eks_private_rt["b"].id
    "c" = aws_route_table.eks_private_rt["c"].id
  }

  route_table_id         = each.value
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.eks_nat_gateway[each.key].id
}

# Security Groups
resource "aws_security_group" "eks_cluster_sg" {
  name        = "eks-cluster-sg"
  description = "Security group for EKS cluster"
  vpc_id      = aws_vpc.eks_vpc.id

  tags = var.tags
}
