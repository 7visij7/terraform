
# Show ip adresses

# output "privete_ip_add_istances" {
#   value = values(aws_instance.web)[*].private_ip
# }


# output "public_ip_add_istances" {
#   # value = values(aws_instance.web)[*].public_ip
#   value = {for k, v in aws_instance.web: k => v.public_ip}
# }


# output "availability_zone" {
#   value = data.aws_availability_zones.available_zones.names
# }

# output "private_subnet_id" {
#   value = aws_subnet.private_subnets.id
# }

# output "public_subnet_id" {
#   value = aws_subnet.public_subnets.id
# }

output "vpc_id" {
  value = module.network.vpc_id
}

output "vpc_security_group_frontend" {
  value = module.network.vpc_security_group_frontend
}

output "vpc_security_group_backend" {
  value =  module.network.vpc_security_group_backend
}

output "vpc_security_group_db" {
  value =  module.network.vpc_security_group_db
}

output "availability_zone_names" {
  value = module.network.availability_zone_names
}

output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "db_subnet_ids" {
  value = module.network.db_subnet_ids
}
