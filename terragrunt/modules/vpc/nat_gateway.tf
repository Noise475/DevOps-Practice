# modules/vpc/nat_gateway.tf

# Elastic IPs for NAT Gateways
resource "aws_eip" "eks_nat_eip" {
  for_each = toset(keys(var.availability_zones))

  tags = merge(var.tags, {
    Name = "nat-eip-${each.key}-${var.environment}"
  })
}

# NAT Gateways
resource "aws_nat_gateway" "eks_nat_gateway" {
  for_each = {
    for az in keys(var.availability_zones) : az => az
  }

  allocation_id = aws_eip.eks_nat_eip[each.key].id
  subnet_id     = aws_subnet.public_subnets[each.key].id

  tags = merge(var.tags, {
    Name = "nat-gateway-${each.key}-${var.environment}"
  })
}
