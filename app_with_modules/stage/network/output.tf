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

output "db_subnet_group_name" {
  value = module.network.db_subnet_group_name
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
