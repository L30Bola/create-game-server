resource "aws_vpc" "terraria-server-vpc" {
  cidr_block = "10.13.37.0/24"

  tags = {
    Name = "terraria-server-vpc"
  }
}

resource "aws_internet_gateway" "terraria-server-vpc-igw" {
  vpc_id = aws_vpc.terraria-server-vpc.id

  tags = {
    Name = "terraria-server-internet-gateway"
  }
}

resource "aws_subnet" "terraria-server-vpc-subnet" {
  vpc_id = aws_vpc.terraria-server-vpc.id
  cidr_block = "10.13.37.0/24"
  availability_zone = local.az
  map_public_ip_on_launch = true

  tags = {
    Name = "terraria-server-vpc-subnet"
  }
}

resource "aws_route_table" "terraria-server-vpc-rt" {
  vpc_id = aws_vpc.terraria-server-vpc.id

  tags = {
    Name = "terraria-server-vpc-route-table"
  }
}

resource "aws_route_table_association" "terraria-server-vpc-router" {
  subnet_id = aws_subnet.terraria-server-vpc-subnet.id
  route_table_id = aws_route_table.terraria-server-vpc-rt.id

  depends_on = [
    aws_subnet.terraria-server-vpc-subnet,
    aws_route_table.terraria-server-vpc-rt
  ]
}

resource "aws_route" "terraria-server-vpc-to-world" {
  route_table_id = aws_route_table.terraria-server-vpc-rt.id
  gateway_id = aws_internet_gateway.terraria-server-vpc-igw.id
  destination_cidr_block = "0.0.0.0/0"

  depends_on = [
    aws_route_table_association.terraria-server-vpc-router
  ]
}


resource "aws_security_group" "terraira-server-vpc-sg" {
  name = "terraria-server-sg"
  description = "Terraria Server security group."
  vpc_id = aws_vpc.terraria-server-vpc.id

  ingress {
    from_port = 7777
    to_port = 7777
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ 
    ]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    self = true
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraria-server-vpc-security-group"
  }
}
