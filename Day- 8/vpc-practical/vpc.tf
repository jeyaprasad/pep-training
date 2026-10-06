resource "aws_vpc" "main" {
  cidr_block       = "13.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "demo-vpclearn"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "13.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "private subnet"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "13.0.2.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "public subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "jp-igw"
  }
}
resource "aws_route_table" "example" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}
resource "aws_route_table_association" "demo" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.example.id
}
