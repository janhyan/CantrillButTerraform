data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_security_group" "a4l-ec2-sg" {
  vpc_id      = aws_vpc.a4l-vpc1.id
  description = "Enable SSH access via port 22 IPv4 & v6"
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
  }
}

resource "aws_instance" "a4l-public" {
  instance_type   = "t2.micro"
  ami             = data.aws_ami.ubuntu.id
  subnet_id       = aws_subnet.a4l-sn["sn-web-A"].id
  security_groups = [aws_security_group.a4l-ec2-sg.id]

  tags = {
    Name = "a4l-publicEC2"
  }
}
