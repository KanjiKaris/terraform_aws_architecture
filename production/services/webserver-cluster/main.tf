module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"

  cluster_name           = "webserver-prod"
  db_remote_state_bucket = "kanji-terraform-state-bucket"
  db_remote_state_key    = "prod/data-stores/mysql/terraform.tfstate"

  instance_type = var.is_production ? "m4.large" : "t2.micro"
  min_size      = 2
  max_size      = 10
}

# resource "aws_autoscaling_schedule" "scale_out" {
#   autoscaling_group_name = module.webserver_cluster.asg_name
#   scheduled_action_name = "scale-out"
#   min_size               = 5
#   max_size               = 10
#   desired_capacity       = 5

#   recurrence = "0 9 * * *"
# }

# resource "aws_autoscaling_schedule" "scale_in" {
#   autoscaling_group_name = module.webserver_cluster.asg_name
#   scheduled_action_name = "scale-in"
#   min_size               = 2
#   max_size               = 5
#   desired_capacity       = 2

#   recurrence = "0 17 * * *"
# }

locals {
  schedules = {
    scale_out = {
      min_size         = 5
      max_size         = 10
      desired_capacity = 5
      recurrence       = "0 9 * * *"
    }

    scale_in = {
      min_size         = 2
      max_size         = 5
      desired_capacity = 2
      recurrence       = "0 17 * * *"
    }
  }
}

resource "aws_autoscaling_schedule" "this" {
  for_each               = var.enable_autoscaling ? local.schedules : {}
  autoscaling_group_name = module.webserver_cluster.asg_name
  scheduled_action_name  = each.key
  min_size               = each.value.min_size
  max_size               = each.value.max_size
  desired_capacity       = each.value.desired_capacity
  recurrence             = each.value.recurrence
}