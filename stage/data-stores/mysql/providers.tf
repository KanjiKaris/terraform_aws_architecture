provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "kanji-terraform-state-bucket"
    key            = "stage/data-stores/mysql/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "kanji-terraform-locks"
    encrypt        = true
  }
}