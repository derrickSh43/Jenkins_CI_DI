//7. Nat Gateway
resource "aws_nat_gateway" "custom_nat_gateway" {
  subnet_id     = element(aws_subnet.front_public_subnet[*].id, 0)
  allocation_id = aws_eip.eip.id
  depends_on    = [aws_internet_gateway.internet_gateway]
  tags = {
    Name = "Custom NAT Gateway",
  }
}
