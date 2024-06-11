# modules/vpc/nat_gateway.tf

# Instance key pair
resource "aws_key_pair" "eks" {
  key_name   = "eks_server_key"
  public_key = var.eks_public_key
}


# Instances for NAT Gateway
resource "aws_instance" "eks_nat_instance_a" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.eks_private_subnet_a.id
  key_name      = aws_key_pair.eks.key_name

}

resource "aws_instance" "eks_nat_instance_b" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.eks_private_subnet_b.id
  key_name      = aws_key_pair.eks.key_name

}

resource "aws_instance" "eks_nat_instance_c" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.eks_private_subnet_c.id
  key_name      = aws_key_pair.eks.key_name

}

# Elastic IPs for NAT Gateways
resource "aws_eip" "eks_nat_eip_a" {

}

resource "aws_eip" "eks_nat_eip_b" {

}

resource "aws_eip" "eks_nat_eip_c" {

}

# NAT Gateways
resource "aws_nat_gateway" "eks_nat_gateway_a" {
  allocation_id = aws_eip.eks_nat_eip_a.id
  subnet_id     = aws_subnet.eks_private_subnet_a.id

}

resource "aws_nat_gateway" "eks_nat_gateway_b" {
  allocation_id = aws_eip.eks_nat_eip_b.id
  subnet_id     = aws_subnet.eks_private_subnet_b.id

}

resource "aws_nat_gateway" "eks_nat_gateway_c" {
  allocation_id = aws_eip.eks_nat_eip_c.id
  subnet_id     = aws_subnet.eks_private_subnet_c.id

}
