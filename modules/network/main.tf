resource "aws_vpc" "lab-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.lab_name}-vpc"
  }
}

resource "aws_internet_gateway" "inet-gateway" {
  vpc_id = aws_vpc.lab-vpc.id
  tags = {
    Name = "${var.lab_name}-inet-gateway"
  }
}

resource "aws_subnet" "sn-public-one" {
  vpc_id     = aws_vpc.lab-vpc.id
  cidr_block = var.public_subnet_one
  tags = {
    Name = "${var.lab_name}-subnet-public-one"
  }
}

resource "aws_subnet" "sn-private-one" {
  vpc_id     = aws_vpc.lab-vpc.id
  cidr_block = var.private_subnet_one
  tags = {
    Name = "${var.lab_name}-subnet-private-one"
  }
}

resource "aws_route_table" "rt-public" {
  vpc_id = aws_vpc.lab-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.inet-gateway.id
  }
  tags = {
    Name = "${var.lab_name}-route-public"
  }
}

resource "aws_route_table" "rt-private" {
  vpc_id = aws_vpc.lab-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }
  tags = {
    Name = "${var.lab_name}-route-private"
  }
}

resource "aws_route_table_association" "rt-association-public" {
  subnet_id      = aws_subnet.sn-public-one.id
  route_table_id = aws_route_table.rt-public.id
}


resource "aws_route_table_association" "rt-association-private" {
  subnet_id      = aws_subnet.sn-private-one.id
  route_table_id = aws_route_table.rt-private.id
}

resource "aws_eip" "natIP" {
  vpc = true
  tags = {
    Name = "${var.lab_name}-natIP"
  }
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.natIP.id
  subnet_id     = aws_subnet.sn-public-one.id
  tags = {
    Name = "${var.lab_name}-nat-gateway"
  }
}

// SG to allow SSH connections from anywhere
resource "aws_security_group" "allow_ssh_pub" {
  name        = "${var.lab-name}-allow-ssh-public"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.lab-vpc.id
  ingress {
    description = "SSH from the internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.public_subnet_one, var.public_subnet_two]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.public_subnet_one, var.public_subnet_two]
  }

  tags = {
    Name = "${var.lab_name}-allow_ssh_pub"
  }
}