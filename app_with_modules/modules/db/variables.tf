######################## Common variables ########################

variable "environment_name" {
  description = "Deployment environment (stage/prod)"
  type        = string
}

variable "app_name" {
  description = "Name of Application"
  type        = string
}

############################# DB ###################################

variable "user_name" {
  description = "Name of db user"
  type        = string
}

variable "db_instance_class" {
  description = "Class of db instance"
  type        = string
}

############################# Network  ###################################

variable "db_subnet_group_name" {
  description = "Subnets group for db"
  type        = string
}

variable "vpc_security_group_db" {
  description = "Security group for db"
  type        = string
}
