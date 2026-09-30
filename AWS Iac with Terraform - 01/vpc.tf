resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  availability_zone = var.az_a
  cidr_block        = var.subnet_a_cidr_block

  tags = {
    Name = var.subnet_a_name
  }
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.main.id
  availability_zone = var.az_b
  cidr_block        = var.subnet_b_cidr_block

  tags = {
    Name = var.subnet_b_name
  }
}

resource "aws_subnet" "public_c" {
  vpc_id            = aws_vpc.main.id
  availability_zone = var.az_c
  cidr_block        = var.subnet_c_cidr_block

  tags = {
    Name = var.subnet_c_name
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id


  tags = {
    Name = var.igw_name
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = var.aws_rt_name
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.main.id
}

