output "address" {
  value       = aws_db_instance.mysql_instance.address
  description = "The address of the MySQL database instance."
}

output "port" {
  value       = aws_db_instance.mysql_instance.port
  description = "The port on which the MySQL database instance is listening."
}