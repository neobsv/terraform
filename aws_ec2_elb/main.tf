# Create an EC2 instance in the public subnet
resource "aws_instance" "instance0" {
  ami           = vars.aws_ami_id
  instance_type = "t3.micro"

  network_interface {
    network_interface_id = aws_network_interface.eni0.id
    device_index         = 0
  }

  tags = {
    Name = "Example EC2 Instance"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_security_group.sg, aws_network_interface.eni0]

}

# Create an EC2 instance in the private subnet
resource "aws_instance" "instance1" {
  ami           = vars.aws_ami_id
  instance_type = "t3.micro"

  network_interface {
    network_interface_id = aws_network_interface.eni1.id
    device_index         = 0
  }

  tags = {
    Name = "Example EC2 Instance"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_security_group.sg_private, aws_network_interface.eni1]
}

# Create a new load balancer
resource "aws_elb" "elb0" {
  name            = "elb0"
  security_groups = [aws_security_group.elb.id]
  subnets         = [aws_subnet.public.id]


  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  instances                   = [aws_instance.instance0.id, aws_instance.instance1.id]
  cross_zone_load_balancing   = false
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "elb0"
  }

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_instance.instance0, aws_instance.instance1]
}
