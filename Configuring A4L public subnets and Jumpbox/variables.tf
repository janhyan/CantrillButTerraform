variable "a4l_vpc" {
  default = "vpc-044612d6d2796d086"
}

variable "a4l_vpc_subnets" {
  type = list(string)
  default = [ "subnet-0547a585a1f1b8168", "subnet-0da2e2d63da2b7c11", "subnet-0e09f645f2a7c0fe2" ]
}
