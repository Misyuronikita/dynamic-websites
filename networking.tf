resource "aws_vpc" "vpc" {
  cidr_block = local.vpc_cidr_block
  tags = {
    Name = "My_VPC"
  }
}

resource "aws_subnet" "subnets" {
  vpc_id            = aws_vpc.vpc.id
  count             = local.subnet_count
  cidr_block        = var.cidr_blocks[count.index]
  availability_zone = var.availability_zone[count.index]
  tags = {
    Name = "Public_Subnets"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "IGW"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = local.anywhere_cidr_block
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Public_RT"
  }
}

resource "aws_route_table_association" "public_rt_association" {
  count          = 2
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.subnets[count.index].id
}
