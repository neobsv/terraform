# DISPATCH: Make a lambda function and an auto scaling cluster with an lb

# Create a lambda Function
locals {
  # Lambda Function vars
  lambda_function_name  = "dispatch_on_asg"
  lambda_runtime        = "python3.12"
  lambda_handler        = "lambda_function.lambda_handler"
  lambda_code_file_path = "lambda_function.zip"

  # Autoscaling Group vars
  asg_ami      = "ami-016038ae9cc8d9f51"
  asg_ami_type = "t3.micro"
}

resource "aws_lambda_function" "lambda0" {
  filename         = local.lambda_code_file_path
  function_name    = local.lambda_function_name
  role             = aws_iam_role.lambda0_role.arn
  handler          = local.lambda_handler
  runtime          = local.lambda_runtime
  memory_size      = 256
  timeout          = 200
  source_code_hash = filebase64sha256(local.lambda_code_file_path)

  vpc_config {
    subnet_ids         = [aws_subnet.private.id]
    security_group_ids = [aws_security_group.lambda0.id]
  }

  lifecycle {
    create_before_destroy = true
  }

  ephemeral_storage {
    size = 512
  }

  tags = {
    Name = "lambda0"
  }

  depends_on = [aws_subnet.private, aws_security_group.lambda0]
}

# Create an auto scaling group
resource "aws_launch_template" "launch_template0" {
  name_prefix   = "launch_template0"
  image_id      = local.asg_ami
  instance_type = local.asg_ami_type
}

resource "aws_autoscaling_group" "asg0" {
  vpc_zone_identifier = [aws_subnet.private.id]
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  health_check_type   = "EC2"

  launch_template {
    id      = aws_launch_template.launch_template0.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_subnet.private]
}

# Create a load balancer for the auto scaling group
resource "aws_lb" "lb" {
  name               = "asg0lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.public.id, aws_subnet.private.id]

  enable_deletion_protection = true

  tags = {
    Name = "asg0_lb"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_subnet.public, aws_subnet.private, aws_security_group.lb_sg]

}
