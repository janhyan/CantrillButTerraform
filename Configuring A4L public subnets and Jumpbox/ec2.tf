resource "tls_private_key" "tf_ec2_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "local_file" "tf_ec2_key" {
  content = tls_private_key.tf_ec2_key.private_key_pem
  filename = "${path.module}/tf_ec2_key.pem"
}

resource "aws_key_pair" "tf_ec2_key" {
  key_name = "tf_ec2_key"
  public_key = tls_private_key.tf_ec2_key.public_key_openssh
}

resource "aws_instance" "a4l-bastion" {
  ami = var.ec2_ami
  instance_type = "t2.micro"
  key_name = aws_key_pair.tf_ec2_key.key_name
  vpc_security_group_ids = [aws_security_group.a4l-sg.id]
  associate_public_ip_address = true
  subnet_id = data.aws_subnet.this["sn-web-A"].id

  tags = {
    Name = "A4L-Bastion"
  }
}