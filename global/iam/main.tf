resource "aws_iam_user" "user" {
  for_each= var.user_names
  name  = each.value
}

data "aws_secretsmanager_secret" "stage_mysql" {
  name = "stage/mysql/master"
}

data "aws_secretsmanager_secret" "production_mysql" {
  name = "production/mysql/master"
}

resource "aws_iam_policy" "read_mysql_secrets" {
  name = "read-mysql-master-secrets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "secretsmanager:GetSecretValue"
      Resource = [
        data.aws_secretsmanager_secret.stage_mysql.arn,
        data.aws_secretsmanager_secret.production_mysql.arn,
      ]
    }]
  })
}