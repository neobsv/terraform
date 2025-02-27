# Create the necessary IAM roles for the lambda function

resource "aws_iam_role" "lambda0_role" {
  name               = "lambda0_role"
  path               = "/system/"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}


resource "aws_iam_role_policy" "lambda0_execute_policy_document" {
  name = "lamda0_execute_policy_document"
  role = aws_iam_role.lambda0_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "autoscaling:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })

  depends_on = [aws_iam_role.lambda0_role]

}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_lambda_vpc_access_execution" {
  role       =  aws_iam_role.lambda0_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"

  depends_on = [aws_iam_role.lambda0_role]
}
