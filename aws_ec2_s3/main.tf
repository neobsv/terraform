# Trying to create automation that performs sharding of requests that hit the ec2 instance
# and move them to the appropriate S3 bucket. This pattern forms a DISTRIBUTED CACHE.

# Create an EC2 instance in the private subnet
resource "aws_instance" "instance0" {
  ami           = vars.aws_ami_id
  instance_type = "t3.micro"

  tags = {
    Name = "Example EC2 Instance"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_security_group.sg_private, aws_network_interface.eni1]
}

# Create an S3 bucket in the private subnet
resource "aws_s3_bucket" "bucket0" {
  bucket        = "example-bucket-private0"
  force_destroy = true

  tags = {
    Name        = "Example S3 Bucket 0"
    Environment = "Development"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create an S3 bucket in the private subnet
resource "aws_s3_bucket" "bucket1" {
  bucket        = "example-bucket-private1"
  force_destroy = true

  tags = {
    Name        = "Example S3 Bucket 1"
    Environment = "Development"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create an S3 bucket in the private subnet
resource "aws_s3_bucket" "bucket2" {
  bucket        = "example-bucket-private2"
  force_destroy = true

  tags = {
    Name        = "Example S3 Bucket 2"
    Environment = "Development"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create a load balancer for the auto scaling group
resource "aws_lb" "lb" {
  name               = "asg0lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.public.id]

  enable_deletion_protection = true

  tags = {
    Name = "ec2_lb"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_subnet.public, aws_security_group.lb_sg]

}