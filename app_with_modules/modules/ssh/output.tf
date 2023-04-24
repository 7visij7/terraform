output "ssh_private_key" {
  value = tls_private_key.rsa.private_key_pem
  sensitive   = true
}

output "ssh_public_key" {
  value =tls_private_key.rsa.public_key_openssh
}

output "ssh_key_name" {
  value = aws_key_pair.ssh_key.key_name
} 
