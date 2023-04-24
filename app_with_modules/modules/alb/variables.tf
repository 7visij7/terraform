######################## Common variables ########################

variable "environment_name" {
  description = "Deployment environment (stage/prod)"
  type        = string
}

variable "app_name" {
  description = "Name of Application"
  type        = string
}

######################## NETWORK ########################

variable "public_subnet_ids" {
  description         = "IDs of public subnets"
}

variable "vpc_id" {
  description         = "Id VPC"
}

############################# EC2 ###################################

variable "frontend_ids" {
  description         = "EC2 frontend ids"
}
