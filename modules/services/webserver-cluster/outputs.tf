# output "public_ip" {
#   value       = aws_instance.example.public_ip
#   description = "The public IP address of the web server instance"
# }


output "asg_name" {
  description = "The name of the Auto Scaling Group"
  value       = aws_autoscaling_group.example_asg.name
}


output "instance_security_group_id" {
  description = "The security group ID of the EC2 instances"
  value       = aws_security_group.instance.id
}