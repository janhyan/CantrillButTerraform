resource "aws_vpc" "a4l-vpc1" {
  cidr_block = "10.16.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "a4l-vpc1"
  }
}

resource "aws_vpc_ipv6_cidr_block_association" "this" {
  vpc_id = aws_vpc.a4l-vpc1.id
  assign_generated_ipv6_cidr_block = true
}

resource "aws_internet_gateway" "a4l-vpc1-igw" {
  vpc_id = aws_vpc.a4l-vpc1.id

  tags = {
    Name = "a4l-vpc1-igw"
  }
}

resource "aws_route_table" "web" {
  vpc_id = aws_vpc.a4l-vpc1.id

  tags = {
    Name = "a4l-vpc1-rt-web"
  }
}

resource "aws_route" "web" {
  route_table_id         = aws_route_table.web.id
  destination_cidr_block = "0.0.0.0/0"
  destination_ipv6_cidr_block = "::/0"
  gateway_id             = aws_internet_gateway.a4l-vpc1-igw.id

  depends_on = [ aws_internet_gateway.a4l-vpc1-igw ]
}

resource "aws_subnet" "a4l-sn" {
  vpc_id = aws_vpc.a4l-vpc1.id

  for_each = var.subnet_config
}