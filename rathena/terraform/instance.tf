resource "aws_security_group" "sg" {
  name = "rathena-server"

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

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = [local.ami_owner]
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-${local.ami_name}-${local.ami_architecture}-server-*"]
  }
}

resource "tls_private_key" "generated_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = local.key_name
  public_key = tls_private_key.generated_key.public_key_openssh
}

resource "aws_instance" "ec2" {
  ami                         = data.aws_ami.ubuntu.id #Ubuntu Server 23.04
  instance_type               = "c6i.xlarge"
  key_name                    = aws_key_pair.generated_key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg.id]

  root_block_device {
    volume_type = "gp3"
    volume_size = "30"

    throughput = 125
    iops       = 3000
  }

  tags = {
    Name      = "rathena-server"
    Permanent = "true"
  }
}
