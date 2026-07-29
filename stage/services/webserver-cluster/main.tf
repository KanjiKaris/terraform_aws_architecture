module "alb" {
  source = "../../../modules/networking/alb"
  cluster_name = "webserver-stage"
}

module "webserver-cluster" {
  source = "../../../modules/services/webserver-cluster"

  cluster_name           = "webserver-stage"
  db_remote_state_bucket = "kanji-terraform-state-bucket"
  db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"
  instance_type          = "t2.micro"
  min_size               = 2
  max_size               = 4

alb_security_group_id = module.alb.alb_security_group_id
target_group_arns = [module.alb.target_group_arn]
subnet_ids = module.alb.subnet_ids
}