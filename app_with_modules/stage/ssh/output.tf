output "ssh_private_key" {
  value = module.ssh.ssh_private_key
  sensitive = true
}

output "ssh_public_key" {
  value = module.ssh.ssh_public_key
}

output "ssh_key_name" {
  value = module.ssh.ssh_key_name
} 
