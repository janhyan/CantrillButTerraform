variable "subnet_config" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
    ipv6_config       = string
    name              = string
  }))

  default = {
    "sn-reserved-A" = { cidr_block = "10.16.0.0/20", availability_zone = "ap-northeast-1a", ipv6_config = "00", name= "sn-reserved-A"}
    "sn-db-A" = { cidr_block = "10.16.16.0/20", availability_zone = "ap-northeast-1a", ipv6_config = "01", name= "sn-db-A"}
    "sn-app-A" = { cidr_block = "10.16.32.0/20", availability_zone = "ap-northeast-1a", ipv6_config = "02", name= "sn-app-A"}
    "sn-web-A" = { cidr_block = "10.16.48.0/20", availability_zone = "ap-northeast-1a", ipv6_config = "03", name= "sn-web-A"}
    "sn-reserved-B" = { cidr_block = "10.16.64.0/20", availability_zone = "ap-northeast-1d", ipv6_config = "04", name= "sn-reserved-B"}
    "sn-db-B" = { cidr_block = "10.16.80.0/20", availability_zone = "ap-northeast-1d", ipv6_config = "05", name= "sn-db-B"}
    "sn-app-B" = { cidr_block = "10.16.96.0/20", availability_zone = "ap-northeast-1d", ipv6_config = "06", name= "sn-app-B"}
    "sn-web-B" = { cidr_block = "10.16.112.0/20", availability_zone = "ap-northeast-1d", ipv6_config = "07", name= "sn-web-B"}
    "sn-reserved-C" = { cidr_block = "10.16.128.0/20", availability_zone = "ap-northeast-1c", ipv6_config = "08", name= "sn-reserved-C"}
    "sn-db-C" = { cidr_block = "10.16.144.0/20", availability_zone = "ap-northeast-1c", ipv6_config = "09", name= "sn-db-C"}
    "sn-app-C" = { cidr_block = "10.16.160.0/20", availability_zone = "ap-northeast-1c", ipv6_config = "10", name= "sn-app-C"}
    "sn-web-C" = { cidr_block = "10.16.176.0/20", availability_zone = "ap-northeast-1c", ipv6_config = "11", name= "sn-web-C"}
}
}



