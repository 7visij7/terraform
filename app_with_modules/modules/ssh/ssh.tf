# Generating public and private keys for access by ssh
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Store private key to catalog ssh
resource "local_file" "tf-key-private" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "ssh/private-key"
  file_permission = "0400"
}

# Store public key to catalog ssh
resource "local_file" "tf-key-public" {
  content  = tls_private_key.rsa.public_key_openssh
  filename = "ssh/public-key"
  file_permission = "0400"
}

# Create AWS ssh key pair
resource "aws_key_pair" "ssh_key" {
  key_name   = "${var.app_name}-${var.environment_name}-ssh-key"
  public_key = tls_private_key.rsa.public_key_openssh
} 