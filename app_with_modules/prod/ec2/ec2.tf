terraform {

  backend "s3" {
    bucket         = "visij-tf-state"
    key            = "use-enviroment/prod/ec2/terraform.tfstate"
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

module "ec2" {
  source = "../../modules/ec2"
  environment_name             = var.environment_name
  app_name                     = var.app_name

  ec2_instance_class           = var.ec2_instance_class

  ssh_key_name                 = data.terraform_remote_state.ssh.outputs.ssh_key_name
  ssh_private_key              = data.terraform_remote_state.ssh.outputs.ssh_private_key

  availability_zone_names      = data.terraform_remote_state.network.outputs.availability_zone_names
  copy_of_application          = var.copy_of_application

  vpc_id                       = data.terraform_remote_state.network.outputs.vpc_id
  private_subnet_ids           = data.terraform_remote_state.network.outputs.private_subnet_ids
  public_subnet_ids            = data.terraform_remote_state.network.outputs.public_subnet_ids
  vpc_security_group_backend   = data.terraform_remote_state.network.outputs.vpc_security_group_backend
  vpc_security_group_frontend  = data.terraform_remote_state.network.outputs.vpc_security_group_frontend
  domain                       = var.domain
}