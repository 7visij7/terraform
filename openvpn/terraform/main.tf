terraform {
  # Assumes s3 bucket and dynamo DB table already set up
  # See /code/03-basics/aws-backend
  backend "s3" {
    bucket         = "visij-tf-state"
    key            = "terraform/openvpn/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }

  required_providers {
    aws = {
      source   = "hashicorp/aws"
      version = "~> 4.16"
    }
    tls = {
      source   = "hashicorp/tls"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


