resource "aws_iam_user" "user" {
  count = var.create_user ? 1 : 0

  name                 = var.name
  path                 = var.path
  force_destroy        = var.force_destroy
  permissions_boundary = var.permissions_boundary

  tags = var.tags
}

resource "aws_iam_user_login_profile" "user_login" {
  count = var.create_user && var.create_iam_user_login_profile ? 1 : 0

  user                    = aws_iam_user.user[0].name
  password_length         = var.password_length
  password_reset_required = var.password_reset_required
}

resource "aws_iam_access_key" "access_key" {
  count = var.create_user && var.create_iam_access_key == "" ? 1 : 0

  user = aws_iam_user.user[0].name
}

resource "aws_iam_user_group_membership" "user_group" {
  user = aws_iam_user.user[0].name

  groups = [data.aws_iam_group.read_only_test.group_name]
}

data "aws_iam_group" "read_only_test" {
  group_name = var.iam_group_name
}