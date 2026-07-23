resource "aws_iam_user" "user" {
  for_each= var.user_names
  name  = each.value
}