terraform {

  backend "s3" {
    bucket         = "visij-tf-state"
    key            = "use-enviroment/stage/ssh/terraform.tfstate"
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


module "ssh" {
  source = "../../modules/ssh"

  environment_name         = var.environment_name
  app_name                 = var.app_name
}