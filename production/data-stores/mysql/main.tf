# resource "aws_db_instance" "mysql-instance" {
#   identifier_prefix    = "kanji-mysql-prod-instance"
#   allocated_storage    = 20
#   storage_type         = "gp2"
#   engine               = "mysql"
#   engine_version       = "8.0"
#   instance_class       = "db.t3.micro"
#   username             = var.db_username
#   password             = var.db_password
#   parameter_group_name = "default.mysql8.0"
#   skip_final_snapshot  = true
# }

data "aws_secretsmanager_secret_version" "db_creds" {
  secret_id = "production/mysql/master"
}

locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.db_creds.secret_string)
}

resource "aws_db_instance" "mysql_instance" {
  identifier_prefix    = "kanji-mysql-instance"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = local.db_creds.username
  password             = local.db_creds.password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
}