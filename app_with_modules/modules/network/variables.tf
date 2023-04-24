variable "environment_name" {
  description = "Deployment environment (stage/prod)"
  type        = string
}

variable "app_name" {
  description = "Application name"
  type        = string
}

variable "vpc_network" {
  description = "VPC CIDR"
}

variable "public_subnets_cidr" {
  description = "Public subnets CIDRs"
}

variable "private_subnets_cidr" {
  description = "Private subnets CIDRs"
}

variable "frontend_ingress_ports" {
  description = "Number of ports for security group"
  type = map(object({
    port          = string
    description   = string
    protocol      = string
  }))
}

variable "backend_ingress_ports" {
  description = "Number of ports for security group"
  type = map(object({
    port          = string
    description   = string
    protocol      = string
  }))
}

variable "db_ingress_ports" {
  description = "Number of ports for security group"
  type = map(object({
    port          = string
    description   = string
    protocol      = string
  }))
}

variable "copy_of_application" {
  description         = "How many copy of application will be deployed"
}
