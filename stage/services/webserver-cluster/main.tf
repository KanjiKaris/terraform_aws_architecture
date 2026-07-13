module "webserver-cluster" {
  source = "../../../modules/services/webserver-cluster"

  cluster_name = "webserver-stage"
  db_remote_state_bucket = "kanji-terraform-state-bucket"
  db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"
  instance_type = "t2.micro"
  min_size = 2
  max_size = 4
  ami_id = "ami-0c55b159cbfafe1f0"
}