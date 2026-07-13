module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"

  cluster_name           = "webserver-prod"
  db_remote_state_bucket = "kanji-terraform-state-bucket"
  db_remote_state_key    = "prod/data-stores/mysql/terraform.tfstate"

  instance_type = "m4.large"
  min_size      = 2
  max_size      = 10
  ami_id        = "ami-0c55b159cbfafe1f0"
}

resource "aws_autoscaling_schedule" "scale_out" {
  autoscaling_group_name = module.webserver_cluster.asg_name
  scheduled_action_name = "scale-out"
  min_size               = 5
  max_size               = 10
  desired_capacity       = 5

  recurrence = "0 9 * * *"
}

resource "aws_autoscaling_schedule" "scale_in" {
  autoscaling_group_name = module.webserver_cluster.asg_name
  scheduled_action_name = "scale-in"
  min_size               = 2
  max_size               = 5
  desired_capacity       = 2

  recurrence = "0 17 * * *"
}