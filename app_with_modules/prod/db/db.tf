terraform {

  backend "s3" {
    bucket         = "visij-tf-state"
    key            = "use-enviroment/prod/db/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.70"

    }
  }
}
provider "aws" {
  region = "us-east-1"
}


module "db" {
  source = "../../modules/db"

  environment_name         = var.environment_name
  app_name                 = var.app_name

  user_name                = var.user_name     
  db_instance_class        = var.db_instance_class
  
}