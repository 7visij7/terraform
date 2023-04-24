# Create frontend instance
resource "aws_instance" "frontend" {
  count                  = var.copy_of_application
  ami                    = data.aws_ami.latest_amazon_ubuntu.id
  instance_type          = var.ec2_instance_class
  availability_zone      = var.availability_zone_names[count.index]
  key_name               = var.ssh_key_name
  subnet_id              = "${var.public_subnet_ids[count.index]}"
  vpc_security_group_ids = [var.vpc_security_group_frontend]

  tags = {
    Name = "${var.app_name}-${var.environment_name}-frontend-${count.index + 1}"
  }
  
  depends_on = [
    aws_instance.backend
  ]

  lifecycle {
    create_before_destroy = true
  }

  provisioner "remote-exec" {
    inline = ["echo 'Wait  until ssh is ready'"]

    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = var.ssh_private_key
      host = self.public_ip
    }
  }

  # provisioner "local-exec" {
  #   command ="ansible-playbook -i ${aws_instance.vpn_server.public_ip}, -u ubuntu ../ansible/openvpn-server.yml --private-key ssh/openvpn-key-private"
  # }
  
  # user_data = file("user_data.sh")
    user_data       = <<-EOF
              #!/bin/bash
              apt update 
              apt install curl
              export IP=$(curl ifconfig.me)
              echo "Hello, World.\n My ip address is $IP." > index.html
              python3 -m http.server 80 &
              EOF
}


# Create backend instance
resource "aws_instance" "backend" {
  count                  = var.copy_of_application
  ami                    = data.aws_ami.latest_amazon_ubuntu.id
  instance_type          = var.ec2_instance_class
  availability_zone      = var.availability_zone_names[count.index]
  key_name               = var.ssh_key_name
  subnet_id              = var.private_subnet_ids[count.index]
  vpc_security_group_ids = [var.vpc_security_group_backend]

  tags = {
    Name = "${var.app_name}-${var.environment_name}-backend-${count.index + 1}"
  }
  
  lifecycle {
    create_before_destroy = true
  }

  # provisioner "local-exec" {
  #   command ="ansible-playbook -i ${aws_instance.vpn_server.public_ip}, -u ubuntu ../ansible/openvpn-server.yml --private-key ssh/openvpn-key-private"
  # }
  
  # user_data = file("user_data.sh")
}



########################### LOAD BALANCER ################################

module "alb" {
  source                       = "../alb"
  count                        = length(aws_instance.frontend[*]) > 1 ? 1 : 0  #  At least two subnets in two different Availability Zones must be specified
  environment_name             = var.environment_name
  app_name                     = var.app_name
  frontend_ids                 = aws_instance.frontend[*].id
  public_subnet_ids            = var.public_subnet_ids[*]
  vpc_id                       = var.vpc_id
}

module "dns" {
  source = "../dns"
  environment_name             = var.environment_name
  app_name                     = var.app_name
  load_balancer_dns_name       = try(module.alb[0].load_balancer_dns_name, "")
  load_balancer_zone_id        = try(module.alb[0].load_balancer_zone_id, "")
  domain                       = var.domain
  public_ip                    = aws_instance.frontend[*].public_ip
  copy_of_application          = var.copy_of_application
  depends_on = [
     module.alb
  ]
}