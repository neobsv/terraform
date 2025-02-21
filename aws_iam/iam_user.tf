# Create an IAM automation user with the default policies attached to it.

resource "aws_iam_user" "automation" {
  name = "automation"
  permissions_boundary = "arn:aws:iam::aws:policy/AdministratorAccess"
  force_destroy = "true"

  tags = {
    Name = "automation_user"
  }
}

resource "aws_iam_access_key" "automation" {
  user = aws_iam_user.automation.name
}

resource "aws_iam_user_policy_attachment" "attach_IAM_password_policy" {
  user  = aws_iam_user.automation.name
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

resource "aws_iam_user_policy_attachment" "attach_EC2_full_access_policy" {
  user  = aws_iam_user.automation.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}
