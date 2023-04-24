# Generating public and private keys for access by ssh
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "tf-key-private" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "ssh/openvpn-key-private"
  file_permission = "0400"
}

resource "local_file" "tf-key-public" {
  content  = tls_private_key.rsa.public_key_openssh
  filename = "ssh/openvpn-key-public"
  file_permission = "0400"
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "openvpn_ssh_key"
  public_key = tls_private_key.rsa.public_key_openssh
} 