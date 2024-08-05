# modules/vpc/nat_gateway.tf

# Instance key pair
resource "aws_key_pair" "eks" {
  key_name   = "${var.environment}_eks_server_key"
  public_key = var.eks_public_key

  tags = var.tags
}


# Instances for NAT Gateway
resource "aws_instance" "eks_nat_instance" {
  for_each = {
    "a" = aws_subnet.private_subnets["a"].id
    "b" = aws_subnet.private_subnets["b"].id
    "c" = aws_subnet.private_subnets["c"].id
  }

  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  subnet_id     = each.value
  key_name      = aws_key_pair.eks.key_name

  tags = merge(var.tags,
  { Name = "nat-instance-${each.key}-${var.environment}" })
}

# Elastic IPs for NAT Gateways
resource "aws_eip" "eks_nat_eip" {
  for_each = toset(["a", "b", "c"])

  tags = merge(var.tags,
  { Name = "nat-eip-${each.key}-${var.environment}" })
}

# NAT Gateways
resource "aws_nat_gateway" "eks_nat_gateway" {
  for_each = toset(["a", "b", "c"])

  allocation_id = aws_eip.eks_nat_eip[each.key].id
  subnet_id     = aws_subnet.public_subnets[each.key].id

  tags = merge(var.tags,
  { Name = "nat-gateway-${each.key}-${var.environment}" })
}
