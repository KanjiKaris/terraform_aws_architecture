output "alb_dns_name" {
  value       = aws_lb.example.dns_name
  description = "The DNS name of the Application Load Balancer"
}

output "alb_security_group_id" {
  description = "The security group ID of the Application Load Balancer"
  value       = aws_security_group.alb.id
}

output "target_group_arn" {
  description = "The ARN of the ALB target group the ASG should register into"
  value       = aws_lb_target_group.asg.arn
}

output "subnet_ids" {
  description = "Default VPC subnet IDs, reusable by cluster module's ASG"
  value       = data.aws_subnets.default.ids
}