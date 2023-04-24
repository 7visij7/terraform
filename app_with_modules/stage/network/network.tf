terraform {

  backend "s3" {
    bucket         = "visij-tf-state"
    key            = "use-enviroment/stage/network/terraform.tfstate"
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

module "network" {
  source = "../../modules/network"
 
  environment_name         = var.environment_name
  app_name                 = var.app_name

  vpc_network              = var.vpc_network
  public_subnets_cidr      = var.public_subnets_cidr
  private_subnets_cidr     = var.private_subnets_cidr

  copy_of_application      = var.copy_of_application
  frontend_ingress_ports   = var.frontend_ingress_ports
  backend_ingress_ports    = var.backend_ingress_ports
  db_ingress_ports         = var.db_ingress_ports
}