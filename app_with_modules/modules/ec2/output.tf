
output "backend_ips" {
  value = aws_instance.backend[*].private_ip
}

output "frontend_ips" {
  value = aws_instance.frontend[*].public_ip
}

output "dns_name" {
  value = module.dns.dns_name
}
