# VPC
resource "aws_vpc" "a4l-vpc1" {
  cidr_block           = "10.16.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "a4l-vpc1"
  }
}

# IPv6 FOR VPC
resource "aws_vpc_ipv6_cidr_block_association" "this" {
  vpc_id                           = aws_vpc.a4l-vpc1.id
  assign_generated_ipv6_cidr_block = true
}

# Internet Gateway For VPC
resource "aws_internet_gateway" "a4l-vpc1-igw" {
  vpc_id = aws_vpc.a4l-vpc1.id

  tags = {
    Name = "a4l-vpc1-igw"
  }
}

# Subnets for web, app, db, and reserve
resource "aws_subnet" "a4l-sn" {
  for_each = var.subnet_config

  vpc_id   = aws_vpc.a4l-vpc1.id
  cidr_block = each.value.cidr_block
  assign_ipv6_address_on_creation = true
  ipv6_cidr_block = cidrsubnet(aws_vpc.a4l-vpc1.ipv6_cidr_block, 8, each.value.ipv6_config)
  availability_zone = each.value.availability_zone

  # If web subnet, assign ipv4
  map_public_ip_on_launch = contains(["sn-web-A", "sn-web-B", "sn-web-C"], each.value.name) ? true : false

  tags = {
    Name = each.value.name
  }
}

# Route table for web subnets
resource "aws_route_table" "web" {
  vpc_id = aws_vpc.a4l-vpc1.id

  tags = {
    Name = "a4l-vpc1-rt-web"
  }
}

# IPv4 route
resource "aws_route" "web_ipv4" {
  route_table_id         = aws_route_table.web.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.a4l-vpc1-igw.id

  depends_on = [aws_internet_gateway.a4l-vpc1-igw]
}

# IPv6 route
resource "aws_route" "web_ipv6" {
  route_table_id              = aws_route_table.web.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.a4l-vpc1-igw.id

  depends_on = [aws_internet_gateway.a4l-vpc1-igw]
}

# Attach web route table to web subnets
resource "aws_route_table_association" "rt-web-sn" {
  for_each = {
    "sn-web-A" = aws_subnet.a4l-sn["sn-web-A"].id
    "sn-web-B" = aws_subnet.a4l-sn["sn-web-B"].id
    "sn-web-C" = aws_subnet.a4l-sn["sn-web-C"].id
  }

  subnet_id      = each.value
  route_table_id = aws_route_table.web.id
}
