data "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = "stage/mysql/master"
}

locals {
  db_credentials = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)
}

resource "aws_db_instance" "mysql_instance" {
  identifier_prefix    = "kanji-mysql-instance"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = local.db_credentials.username
  password             = local.db_credentials.password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
}