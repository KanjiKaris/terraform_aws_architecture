output "alb_dns_name" {
  value       = module.webserver_cluster.alb_dns_name
  description = "The DNS name of the Application Load Balancer"
}

output "asg_name" {
  description = "The name of the Auto Scaling Group"
  value       = module.webserver_cluster.asg_name
}

output "alb_security_group_id" {
  description = "The security group ID of the Application Load Balancer"
  value       = module.webserver_cluster.alb_security_group_id
}

output "instance_security_group_id" {
  description = "The security group ID of the EC2 instances"
  value       = module.webserver_cluster.instance_security_group_id
}