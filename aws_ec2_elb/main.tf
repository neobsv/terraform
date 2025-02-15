terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-north-1"
}

# Create an EC2 instance in the public subnet
resource "aws_instance" "instance0" {
  ami           = "ami-07a64b147d3500b6a"
  instance_type = "t3.micro"

  network_interface {
    network_interface_id  = aws_network_interface.eni.0.id
    device_index          = 0
  }

  tags = {
    Name = "Example EC2 Instance"
  }

  lifecycle {
    create_before_destroy = true
  }

}

# Create an EC2 instance in the public subnet
resource "aws_instance" "instance1" {
  ami           = "ami-07a64b147d3500b6a"
  instance_type = "t3.micro"

  network_interface {
    network_interface_id  = aws_network_interface.eni.1.id
    device_index          = 0
  }

  tags = {
    Name = "Example EC2 Instance"
  }

  lifecycle {
    create_before_destroy = true
  }

}