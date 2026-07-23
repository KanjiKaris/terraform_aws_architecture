variable "user_names" {
  description = "create IAM users with these names"
  type        = set(string)
  default     = ["neo", "morpheus"]
}