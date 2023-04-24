######################## Common variables ########################

variable "environment_name" {
  description = "Deployment environment (stage/prod)"
  type        = string
}

variable "app_name" {
  description = "Name of Application"
  type        = string
}

######################## SSH ########################

variable "ssh_key_name" {
  description         = "SSH key"
}

variable "ssh_private_key" {
  description         = "Private SSH key"
}

######################## NETWORK ########################

variable "vpc_security_group_frontend" {
  description         = "Security group for frontend"
}

variable "vpc_security_group_backend" {
  description         = "Security group for backend"
}

variable "public_subnet_ids" {
  description         = "IDs of public subnets"
}

variable "private_subnet_ids" {
  description         = "IDs of private subnets"
}

variable "vpc_id" {
  description         = "Id VPC"
}

variable "availability_zone_names" {
  description         = "availability_zone_names"
}

variable "copy_of_application" {
  description         = "How many copy of application will be deployed"
}

############################# EC2 ###################################

variable "ec2_instance_class" {
  description = "Class of EC2 instance"
  type        = string
}

######################## DNS ########################

variable "domain" {
  description = "Domain"
  type        = string
}