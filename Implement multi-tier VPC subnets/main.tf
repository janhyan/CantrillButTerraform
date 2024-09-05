resource "aws_vpc" "a4l-vpc1" {
  cidr_block           = "10.16.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  assign_generated_ipv6_cidr_block = "true"
  tags = {
    Name = "a4l-vpc1"
  }
}
  
resource "aws_subnet" "sn-reserved-A" {
  for_each = var.subnet_config

  vpc_id = aws_vpc.a4l-vpc1.id
  cidr_block = each.value.cidr_block
  assign_ipv6_address_on_creation = true
  ipv6_cidr_block = cidrsubnet(aws_vpc.a4l-vpc1.ipv6_cidr_block, 8, each.value.ipv6_config)
  availability_zone = each.value.availability_zone

  tags = {
    Name = each.value.name
  }
}
