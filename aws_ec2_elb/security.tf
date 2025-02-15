# Security Group for VPC 0
resource "aws_security_group" "sg" {
  name        = "vpc0_sg"
  description = "Allow inbound traffic on port 22 (SSH)"
  vpc_id      = aws_vpc.vpc0.id

  # inbound traffic only on port 22 (SSH)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.all_cidr_block
  }

  # inbound traffic only on port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.all_cidr_block
  }

  # default deny all egress traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" 
    cidr_blocks = var.all_cidr_block
  }

  tags = {
    Name = "security_group_vpc0"
  }
  
  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_vpc.vpc0]
}

resource "aws_security_group" "elb" {
  name        =  "elb_sg"
  description = "Allow inbound traffic on port 80"
  vpc_id      = aws_vpc.vpc0.id

  # inbound traffic only on port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.all_cidr_block
  }

  # default deny all egress traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" 
    cidr_blocks = var.all_cidr_block
  }

  tags = {
    Name = "security_group_elb0"
  }
  
  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_vpc.vpc0]

}

# Network ACL for Internet Gateway
resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.vpc0.id

# for api calls
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 443
    to_port    = 443
  }

# for api calls
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 80
    to_port    = 80
  }

# for api calls
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 80
    to_port    = 80
  }

# for api calls
  ingress {
    protocol   = "tcp"
    rule_no    = 400
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 443
    to_port    = 443
  }

# for ssh access to ec2 instances
  ingress {
    protocol   = "tcp"
    rule_no    = 500
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 22
    to_port    = 22
  }

  tags = {
    Name = "network_acl_0"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_vpc.vpc0]
}
