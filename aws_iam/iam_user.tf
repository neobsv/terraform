# Create an IAM automation user with the default policies attached to it.

resource "aws_iam_user" "automation" {
  name                 = "automation"
  path                 = "/system/"
  permissions_boundary = "arn:aws:iam::aws:policy/AdministratorAccess"
  force_destroy        = "true"

  tags = {
    Name = "automation_user"
  }
}

resource "aws_iam_access_key" "automation" {
  user = aws_iam_user.automation.name
}

locals {
  default_policy_arns = [
    "arn:aws:iam::aws:policy/IAMUserChangePassword",
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  ]

  group_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AutoScalingFullAccess",
    "arn:aws:iam::aws:policy/AWSLambda_FullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
  ]
}

resource "aws_iam_user_policy_attachment" "attach_default_policies" {
  for_each = toset(local.default_policy_arns)

  user       = aws_iam_user.automation.name
  policy_arn = each.value
}

# Create an IAM Group for the automation user.

resource "aws_iam_group" "automation_group" {
  name = "automation_group"
  path = "/system/"
}

# Attach additional policies to the automation group, those ones that are not safe to be attached to a user exclusively.

resource "aws_iam_group_policy_attachment" "attach_group_policies" {
  for_each = toset(local.group_policy_arns)

  group      = aws_iam_group.automation_group.name
  policy_arn = each.value
}
