data "aws_vpc" "a4l_vpc" {
  id = var.a4l_vpc
}

data "aws_subnets" "this" {
  filter {
    name   = "vpc-id"
    values = [var.a4l_vpc]
  }
}

data "aws_subnet" "this" {
  for_each = toset(data.aws_subnets.this.ids)
  id       = each.value
}



resource "aws_internet_gateway" "this" {
  vpc_id = data.aws_vpc.a4l_vpc.id

  tags = {
    Name = "a4l-igw"
  }
}

resource "aws_route_table" "this" {
  vpc_id = data.aws_vpc.a4l_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.this.id
  }

  tags = {
    Name = "a4l-vpc1-rt-web"
  }
}

resource "aws_route_table_association" "this" {
  for_each       = toset(var.a4l_vpc_subnets)
  subnet_id      = each.value
  route_table_id = aws_route_table.this.id
}
