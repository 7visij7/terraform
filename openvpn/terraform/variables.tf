# should specify optional vs required
variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default = "10.1.0.0/16"
}
variable "cidr_subnet" {
  description = "CIDR block for the subnet"
  default = "10.1.1.0/24"
}

variable "instance_type" {
  description = "instance_type"
  type        = string
  default = "t2.micro"
}


variable "ec2_ingress_ports" {
  type = map(object({
    port          = string
    description   = string
    protocol      = string
  }))

  default = {
    "opanvpn" = {
      port        = 51820
      description = "openssh from VPC"
      protocol    = "UDP"
    }
    "ssh" = {
      port        = 22
      description = "ssh from VPC"
      protocol    = "TCP"
    }
  }
}
