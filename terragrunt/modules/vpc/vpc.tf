# modules/vpc/main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Create a map from subnet ID to its index in the private subnets; 
# Allows round robin AZ assignment
locals {
  subnet_ids        = [for subnet in aws_subnet.private_subnets : subnet.id]
  route_table_ids   = [for rt in aws_route_table.eks_private_rt_table : rt.id]
  route_table_count = length(local.route_table_ids)
}

# Instance key pair
resource "aws_key_pair" "eks" {
  key_name   = "${var.environment}_eks_cluster_key"
  public_key = var.eks_public_key

  tags = var.tags
}

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

# Route Table Associations for Public Subnets
resource "aws_route_table_association" "public_subnet_association" {
  for_each = aws_subnet.public_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.eks_public_rt.id
}

# Route to Internet Gateway for Public Subnets
resource "aws_route" "eks_public_rt_route" {
  route_table_id         = aws_route_table.eks_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.eks_igw.id
}

# Public Subnets
resource "aws_subnet" "public_subnets" {
  for_each = var.public_subnet_cidrs

  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = each.value
  availability_zone       = element(values(var.availability_zones), index(keys(var.public_subnet_cidrs), each.key) % length(keys(var.availability_zones)))
  map_public_ip_on_launch = true

  tags = merge(var.tags, { Availability_Zone = element(values(var.availability_zones), index(keys(var.public_subnet_cidrs), each.key) % length(keys(var.availability_zones))) })
}

# Private Subnets
resource "aws_subnet" "private_subnets" {
  for_each = var.private_subnet_cidrs

  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = each.value
  availability_zone = element(values(var.availability_zones), index(keys(var.private_subnet_cidrs), each.key) % length(keys(var.availability_zones)))

  tags = merge(var.tags, { Availability_Zone = element(values(var.availability_zones), index(keys(var.private_subnet_cidrs), each.key) % length(keys(var.availability_zones))) })
}

# Route Tables for Private Subnets
resource "aws_route_table" "eks_private_rt_table" {
  for_each = {
    for az in keys(var.availability_zones) : az => az
  }

  vpc_id = aws_vpc.eks_vpc.id

  tags = merge(var.tags, {
    Name = "private-rt-${each.key}-${var.environment}"
  })
}

resource "aws_route_table_association" "private_subnet_association" {
  count = length(aws_subnet.private_subnets)

  subnet_id      = local.subnet_ids[count.index]
  route_table_id = local.route_table_ids[count.index % local.route_table_count]
}

# Routes For Private Subnets
resource "aws_route" "eks_private_rt" {
  for_each = aws_route_table.eks_private_rt_table

  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"

  nat_gateway_id = aws_nat_gateway.eks_nat_gateway[each.key].id
}
