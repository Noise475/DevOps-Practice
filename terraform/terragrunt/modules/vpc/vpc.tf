# modules/vpc/vpc.terraform

# VPC
resource "aws_vpc" "eks_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# Internet Gateway for Public Subnets
resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_vpc.id
}

# Route Tables for Public Subnets
resource "aws_route_table" "eks_public_rt" {
  vpc_id = aws_vpc.eks_vpc.id
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
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "eks_subnet_b" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "eks_subnet_c" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-west-2c"
  map_public_ip_on_launch = true
}

# Private Subnets
resource "aws_subnet" "eks_private_subnet_a" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "eks_private_subnet_b" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-west-2b"
}

resource "aws_subnet" "eks_private_subnet_c" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "us-west-2c"
}

# NAT Gateway for Private Subnets
resource "aws_nat_gateway" "eks_nat_gateway_a" {
  allocation_id = aws_instance.eks_nat_instance_a.associate_public_ip_address[0].id
  subnet_id     = aws_subnet.eks_private_subnet_a.id
}

resource "aws_nat_gateway" "eks_nat_gateway_b" {
  allocation_id = aws_instance.eks_nat_instance_b.associate_public_ip_address[0].id
  subnet_id     = aws_subnet.eks_private_subnet_b.id
}

resource "aws_nat_gateway" "eks_nat_gateway_c" {
  allocation_id = aws_instance.eks_nat_instance_c.associate_public_ip_address[0].id
  subnet_id     = aws_subnet.eks_private_subnet_c.id
}

# NAT Instances for Private Subnets
resource "aws_instance" "eks_nat_instance_a" {
  ami                         = "ami-xxxxxxxxxxxxxxxxx" # Replace with your NAT instance AMI
  instance_type               = "t2.micro"              # Adjust instance type as needed
  key_name                    = "your-key-pair-name"    # Replace with your key pair name
  subnet_id                   = aws_subnet.eks_subnet_a.id
  associate_public_ip_address = true
}

resource "aws_instance" "eks_nat_instance_b" {
  ami                         = "ami-xxxxxxxxxxxxxxxxx" # Replace with your NAT instance AMI
  instance_type               = "t2.micro"              # Adjust instance type as needed
  key_name                    = "your-key-pair-name"    # Replace with your key pair name
  subnet_id                   = aws_subnet.eks_subnet_b.id
  associate_public_ip_address = true
}

resource "aws_instance" "eks_nat_instance_c" {
  ami                         = "ami-xxxxxxxxxxxxxxxxx" # Replace with your NAT instance AMI
  instance_type               = "t2.micro"              # Adjust instance type as needed
  key_name                    = "your-key-pair-name"    # Replace with your key pair name
  subnet_id                   = aws_subnet.eks_subnet_c.id
  associate_public_ip_address = true
}

# Route Table for Private Subnets
resource "aws_route_table" "eks_private_rt_a" {
  vpc_id = aws_vpc.eks_vpc.id
}

resource "aws_route_table" "eks_private_rt_b" {
  vpc_id = aws_vpc.eks_vpc.id
}

resource "aws_route_table" "eks_private_rt_c" {
  vpc_id = aws_vpc.eks_vpc.id
}

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

  vpc_id = aws_vpc.eks_vpc.id
}
