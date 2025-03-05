# Security Group for public instances
resource "aws_security_group" "sg" {
  name        = "public_sg"
  description = "Allow inbound traffic on port 22 (SSH)"
  vpc_id      = aws_vpc.vpc0.id

  # inbound traffic only on port 22 (SSH)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.all_cidr_block_sg
  }

  # inbound traffic only on port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.all_cidr_block_sg
  }

  # inbound traffic only on port 443
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.all_cidr_block_sg
  }

  tags = {
    Name = "security_group_public"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_vpc.vpc0]
}

# Security Group for private instances
resource "aws_security_group" "sg_private" {
  name        = "private_sg"
  description = "Allow inbound traffic on port 22 (SSH)"
  vpc_id      = aws_vpc.vpc0.id

  # inbound traffic only on port 22 (SSH)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.vpc_cidr_block_sg
  }

  # inbound traffic only on port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.vpc_cidr_block_sg
  }

  # inbound traffic only on port 443
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.vpc_cidr_block_sg
  }

  tags = {
    Name = "security_group_private"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_vpc.vpc0]
}

resource "aws_security_group" "elb" {
  name        = "elb_sg"
  description = "Allow inbound traffic on port 80"
  vpc_id      = aws_vpc.vpc0.id

  # inbound traffic only on port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.all_cidr_block_sg
  }

  # inbound traffic only on port 443
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.all_cidr_block_sg
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
  vpc_id     = aws_vpc.vpc0.id
  subnet_ids = [aws_subnet.private.id, aws_subnet.public.id]

  # for api calls
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.all_cidr_blocks
    from_port  = 80
    to_port    = 80
  }

  # for api calls
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.all_cidr_blocks
    from_port  = 443
    to_port    = 443
  }

  # for ssh access to ec2 instances
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.all_cidr_blocks
    from_port  = 22
    to_port    = 22
  }

  # egress allow all for outbound traffic
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.all_cidr_blocks
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "network_acl_0"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_vpc.vpc0]
}
