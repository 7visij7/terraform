
# cd stage;
# CURRENT_PATH=$(pwd);
# for i in $(ls -d */);do ln -s $CURRENT_PATH/variables.tf $CURRENT_PATH/${i}variables.tf ;done

######################## Common variables ########################

variable "environment_name" {
  description         = "Environment"
  default             = "stage"
}

variable "copy_of_application" {
  description         = "How many copy of application will be deployed"
  default             = 1
}

variable "region" {
  description         = "Region"
  default             = "us-east-1"
}

variable "app_name" {
  description         = "Name of Application"
  default             = "web-server"
}

######################## NETWORK ########################

variable "vpc_network" {
  type    = map
  default = {
    "dev"   = "10.22.0.0/16"
    "stage" = "10.23.0.0/16"
    "prod"  = "10.24.0.0/16"
  }
}

variable "private_subnets_cidr" {
  type    = map
  default = {
    "dev"   = ["10.22.1.0/16", "10.22.2.0/16"]
    "stage" = ["10.23.11.0/16", "10.23.12.0/16"]
    "prod"  = ["10.24.21.0/16", "10.24.22.0/16"]
  }
}

variable "public_subnets_cidr" {
  type    = map
  default = {
    "dev"   = ["10.22.3.0/16", "10.22.2.0/16"]
    "stage" = ["10.23.13.0/16", "10.23.14.0/16"]
    "prod"  = ["10.24.23.0/16", "10.24.24.0/16"]
  }
}

variable "frontend_ingress_ports" {
  type = map(object({
    port          = string
    description   = string
    protocol      = string
  }))

  default = {
    "http" = {
      port        = 80
      description = "http from VPC"
      protocol    = "TCP"
    }
    "https" = {
      port        = 443
      description = "https from VPC"
      protocol    = "TCP"
    }
    "ssh" = {
      port        = 22
      description = "ssh from VPC"
      protocol    = "TCP"
    }
  }
}

variable "backend_ingress_ports" {
  type = map(object({
    port          = string
    description   = string
    protocol      = string
  }))

  default = {
    "backend" = {
      port        = 8080
      description = "http from VPC"
      protocol    = "TCP"
    }
    "ssh" = {
      port        = 22
      description = "ssh from VPC"
      protocol    = "TCP"
    }
  }
}

variable "db_ingress_ports" {
  type = map(object({
    port          = string
    description   = string
    protocol      = string
  }))

  default = {
    "mysql" = {
      port        = 3306
      description = "Mysql from VPC"
      protocol    = "TCP"
    }
  }
}

######################## DB ########################

variable "user_name" {
  description = "Name of db user"
  type        = string
  default     = "admin"
}

variable "db_instance_class" {
  description = "Class of db instance"
  type        = string
  default     = "db.t2.micro"
}

######################## EC2 ########################

variable "ec2_instance_class" {
  description = "Class of EC2 instance"
  type        = string
  default     = "t2.micro"
}

######################## DNS ########################

variable "domain" {
  description = "Domain"
  type        = string
  default     = "stage-7visij7.com"
}