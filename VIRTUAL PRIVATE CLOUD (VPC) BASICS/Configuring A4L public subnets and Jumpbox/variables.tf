variable "a4l_vpc" {
  default = "vpc-044612d6d2796d086"
}

variable "a4l_vpc_subnets" {
  type = list(string)
  default = [ "subnet-0547a585a1f1b8168", "subnet-0da2e2d63da2b7c11", "subnet-0e09f645f2a7c0fe2" ]
}

variable "private_route_tables" {
  default = {
    "private-rt-A" = "ap-northeast-1a"
    "private-rt-B" = "ap-northeast-1b"
    "private-rt-C" = "ap-northeast-1c"
  }
}

variable "ec2_ami" {
  description = "AMI for the Amazon Linux"
}
