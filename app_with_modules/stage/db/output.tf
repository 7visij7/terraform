output "rds_hostname" {
  description = "RDS instance hostname"
  value       = module.db.rds_hostname
}

output "rds_port" {
  description = "RDS instance port"
  value       = module.db.rds_port
}

output "rds_username" {
  description = "RDS instance root username"
  value       = module.db.rds_username
}