
output "backend_ips" {
  value = module.ec2.backend_ips
}

output "frontend_ips" {
  value = module.ec2.frontend_ips
}

output "app_name" {
  value = var.app_name
}

output "dns_name" {
  value = module.ec2.dns_name
}
