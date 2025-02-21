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

data "aws_iam_policy" "ec2_full_access" {
    arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

data "aws_iam_policy" "iam_change_password" {
    arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

resource "aws_iam_user_policy_attachment" "default_policies" {
  for_each = toset([
    data.aws_iam_policy.ec2_full_access.arn,
    data.aws_iam_policy.iam_change_password.arn
  ])

  user       = aws_iam_user.automation.name
  policy_arn = each.value
}