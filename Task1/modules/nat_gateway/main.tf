resource "aws_eip" "nat" {

  tags = {
    Name = "${var.vpc_name}-nat-eip"
  }
  
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id    = var.public_subnet_id

  tags = {
    Name = "${var.vpc_name}-nat-gateway"
  }
}