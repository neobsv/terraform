# Create a VPC
resource "aws_vpc" "vpc0" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc0"
  }

}

# Create a public subnet within the VPC, to host the Elastic Load Balancer
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.vpc0.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = "eu-north-1a"

  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_vpc.vpc0]
}

# Create a private subnet within the VPC, to host instances
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.vpc0.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "eu-north-1a"

  map_public_ip_on_launch = false

  tags = {
    Name = "private_subnet"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_vpc.vpc0]
}

# Create a network interface for the public subnet
resource "aws_network_interface" "eni0" {
  subnet_id       = aws_subnet.public.id
  private_ips     = var.public_network_interface_ip0
  security_groups = [aws_security_group.sg.id]

  tags = {
    Name        = "public_eni0"
    Description = "Public network interface for instances"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_subnet.public]
}

# Create a network interface for the private subnet
resource "aws_network_interface" "eni1" {
  subnet_id       = aws_subnet.private.id
  private_ips     = var.private_network_interface_ip1
  security_groups = [aws_security_group.sg_private.id]

  tags = {
    Name        = "private_eni1"
    Description = "Private network interface for instances"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_subnet.private]
}

# Create an Internet Gateway for the VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc0.id

  tags = {
    Name = "internet_gateway"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_vpc.vpc0]
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc0.id

  tags = {
    Name = "route_table0"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_vpc.vpc0]
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_route_table.route_table]
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.route_table.id

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_route_table.route_table, aws_subnet.public]
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.route_table.id

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_route_table.route_table, aws_subnet.private]
}
