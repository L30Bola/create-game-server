locals {
  rathena_ports = [
    {
      port        = -1
      description = "ICMP (Ping)"
      protocol    = "icmp"
    },
    {
      port        = 22
      description = "SSH"
      protocol    = "tcp"
    },
    {
      port        = 6900
      description = "Login Server"
      protocol    = "tcp"
    },
    {
      port        = 6121
      description = "Char Server"
      protocol    = "tcp"
    },
    {
      port        = 5121
      description = "Map Server"
      protocol    = "tcp"
    },
    {
      port        = 8888
      description = "Web Server"
      protocol    = "tcp"
    }
  ]
}

resource "aws_security_group" "sg" {
  name = "leonardo-godoy"

  dynamic "ingress" {
    for_each = local.rathena_ports
    content {
      protocol         = ingress.value.protocol
      from_port        = ingress.value.port
      to_port          = ingress.value.port
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "rAthena ${ingress.value.description} port"
    }
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
