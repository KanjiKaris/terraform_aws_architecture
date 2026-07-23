variable "enable_autoscaling" {
  description = "Whether to enable scheduled autoscaling"
  type        = bool
  default     = true
}

variable "is_production" {
  description = "Whether this is a production environment"
  type        = bool
  default     = true
}
