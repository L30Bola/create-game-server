resource "aws_security_group" "sg" {
  name = "leonardo-godoy"

  ingress {
    from_port = -1
    to_port   = -1
    protocol  = "icmp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "ec2" {
  ami                         = "ami-0bd8c2c70c6607283" #Ubuntu Server 23.04
  instance_type               = "c6i.xlarge"
  key_name                    = "leonardo-godoy"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg.id]

  root_block_device {
    volume_type = "gp3"
    volume_size = "30"

    throughput = 125
    iops       = 3000
  }

  tags = {
    Name      = "leonardo-godoy"
    Permanent = "true"
  }
}
