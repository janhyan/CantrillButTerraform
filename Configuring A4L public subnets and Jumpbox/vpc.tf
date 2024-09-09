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


# CREATE VPC RESOURCES
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

resource "aws_security_group" "a4l-sg" {
  name        = "a4l-sg"
  description = "Security group allowing SSH for A4L Bastion"
  vpc_id = data.aws_vpc.a4l_vpc.id

  # SSH ingress rule
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # TCP port 80 for HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # TCP port 443 for HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound HTTP to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound HTTPS to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

############# NAT GATEWAY ##############
resource "aws_nat_gateway" "a4l-vpc1-natgw" {
  for_each = toset(data.aws_subnets.this.ids)
  subnet_id = each.value
  connectivity_type = "public"

  tags = {
    Name = "a4l-vpc1-natgw-${each.key}"
  }

  depends_on = [ aws_internet_gateway.this ]
}

############# ROUTE TABLE FOR BACKEND ##############
resource "aws_route_table" "a4l-private-rt" {
  for_each = var.private_route_tables
  vpc_id = data.aws_vpc.a4l_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.a4l-vpc1-natgw[each.key].id
  }

  tags = {
    Name = each.key
  }
}
