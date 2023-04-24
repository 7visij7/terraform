
output "availability_zone_names" {
  value = data.aws_availability_zones.available_zones.names
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "db_subnet_ids" {
  value = aws_subnet.db_subnets[*].id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.group_db_subnets.name
}


output "db_subnet_group_id" {
  value = aws_db_subnet_group.group_db_subnets.id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_security_group_frontend" {
  value = aws_security_group.sg_frontend.id
}

output "vpc_security_group_backend" {
  value =  aws_security_group.sg_backend.id
}

output "vpc_security_group_db" {
  value =  aws_security_group.sg_db.id
}