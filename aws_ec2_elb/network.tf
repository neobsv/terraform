# Create a VPC
resource "aws_vpc" "vpc0" {
  cidr_block = var.vpc_cidr

  lifecycle {
    create_before_destroy = true
  }
}

# Create a public subnet within the VPC, to host the Elastic Load Balancer
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.vpc0.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.availability_zone

  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet"
  }
  
  lifecycle {
    create_before_destroy = true
  }
}

# Create a private subnet within the VPC, to host instances
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.vpc0.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone

  map_public_ip_on_launch = false

  tags = {
    Name = "private_subnet"
  }
  
  lifecycle {
    create_before_destroy = true
  }
}

# Create a network interface for the private subnet
resource "aws_network_interface" "eni" {
  subnet_id      = aws_subnet.private.id
  private_ips    = var.private_network_interface_ips
  count          = 2

  tags = {
    Name = "private_eni"
    Description = "Private network interface for instances"
  }
  
  lifecycle {
    create_before_destroy = true
  }
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
}
