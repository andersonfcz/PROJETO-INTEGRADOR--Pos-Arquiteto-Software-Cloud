resource "aws_nat_gateway" "nat-a" {
  allocation_id = aws_eip.nat-a.allocation_id
  subnet_id     = aws_subnet.public-a.id
  depends_on    = [aws_internet_gateway.igw]
}

resource "aws_eip" "nat-a" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat-b" {
  allocation_id = aws_eip.nat-b.allocation_id
  subnet_id     = aws_subnet.public-b.id
  depends_on    = [aws_internet_gateway.igw]
}

resource "aws_eip" "nat-b" {
  domain = "vpc"
}