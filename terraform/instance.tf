resource "aws_instance" "ec2" {
  ami = "ami-07ebfd5b3428b6f4d" #Ubuntu Server 20.04 LTS
  instance_type = "t2.medium"
  availability_zone = local.az
  count = 1
  key_name = aws_key_pair.key.key_name
  vpc_security_group_ids = [ aws_security_group.terraira-server-vpc-sg.id ]
  subnet_id = aws_subnet.terraria-server-vpc-subnet.id

  root_block_device {
    volume_type = "gp2"
    volume_size = "8"
  }

  tags = {
    Name = "terraria-server-${count.index}"
  }
}
