variable "db_remote_state_bucket" {
  description = "S3 bucket for the DB's remote state"
  type        = string
}

variable "db_remote_state_key" {
  description = "Path for the DB's remote state key"
  type        = string
}

variable "instance_type" {
  description = "The instance type to use for the webserver instances"
  type        = string
}

variable "min_size" {
  description = "The minimum number of EC2 instances in the ASG"
  type        = number
}

variable "max_size" {
  description = "The maximum number of EC2 instances in the ASG"
  type        = number
}

variable "alb_security_group_id" {
  description = "The security group ID of the ALB, used to restrict instance ingress to ALB traffic only"
  type        = string
}

variable "target_group_arns" {
  description = "List of ALB target group ARNs the ASG instances should register into"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs to launch ASG instances into"
  type        = list(string)
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type        = string
}
