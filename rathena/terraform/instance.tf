resource "aws_instance" "ec2" {
  ami = "ami-0bd8c2c70c6607283" #Ubuntu Server 23.04
  instance_type = "c6i.xlarge"
  key_name = "leonardo-godoy"
  associate_public_ip_address = true

  root_block_device {
    volume_type = "gp3"
    volume_size = "30"

    throughput = 125
    iops = 3000
  }

  tags = {
    Name = "leonardo-godoy"
    Permanent = "true"
  }
}
