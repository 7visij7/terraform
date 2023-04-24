######################## Common variables ########################

variable "environment_name" {
  description = "Deployment environment (stage/prod)"
  type        = string
}

variable "app_name" {
  description = "Name of Application"
  type        = string
}

variable "copy_of_application" {
  description         = "How many copy of application will be deployed"
}

############################### DNS ###############################

variable "load_balancer_dns_name" {
  description = "ALB dns name"
  type        = string
}

variable "load_balancer_zone_id" {
  description = "ALB zone id"
  type        = string
}

variable "domain" {
  description = "Name of domain"
  type        = string
}


variable "public_ip" {
  description = "Public ips"
}