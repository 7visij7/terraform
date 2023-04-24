
resource "aws_instance" "vpn_server" {
  ami                    = data.aws_ami.latest_amazon_ubuntu.id
  instance_type          = "t2.micro"
  availability_zone      = data.aws_availability_zones.available.names[0]
  # key_name               = var.ssh_key
  key_name               = aws_key_pair.ssh_key.key_name
  subnet_id              = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.allow_ssh_vpn.id]

  tags = {
    Name = "OpenVPN server"
  }
  
  lifecycle {
    create_before_destroy = true
  }

  provisioner "remote-exec" {
    inline = ["echo 'Wait  until ssh is ready'"]

    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = tls_private_key.rsa.private_key_pem
      host = aws_instance.vpn_server.public_ip
    }
  }

  provisioner "local-exec" {
    command ="ansible-playbook -i ${aws_instance.vpn_server.public_ip}, -u ubuntu ../ansible/openvpn-server.yml --private-key ssh/openvpn-key-private"
  }
  
  user_data = file("user_data.sh")
}