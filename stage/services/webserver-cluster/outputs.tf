# output "public_ip" {
#   value       = aws_instance.example.public_ip
#   description = "The public IP address of the web server instance"
# }

output "alb_dns_name" {
  value       = aws_lb.example.dns_name
  description = "The DNS name of the Application Load Balancer"
}