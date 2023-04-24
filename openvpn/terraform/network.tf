# Create VPC
resource "aws_vpc" "main" {
  cidr_block = var.cidr_vpc
  enable_dns_hostnames = true

  tags = {
    Name = "VPC for openvpn server"
  }
}

# Create Internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Openvpn Internet Gateway"
  }
}

# Create Subnet
resource "aws_subnet" "subnet" {
  vpc_id               = aws_vpc.main.id
  cidr_block           = var.cidr_subnet
  availability_zone    = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  
  tags = {
    Name = "Subnet for openvpn server"
  }
}

# Create elastic IP
resource "aws_eip" "elastic_ip" {
  instance       = aws_instance.vpn_server.id
  network_interface     = aws_network_interface.openvpn-server-nic.id
  vpc                   = true   

  provisioner "local-exec" {
    command ="ansible-playbook -i ${aws_eip.elastic_ip.public_ip}, -u ubuntu ../ansible/openvpn-client.yml --private-key ssh/openvpn-key-private --extra-vars=\"SERVER_IP=${aws_eip.elastic_ip.public_ip}\""
  }
  
#  ansible-playbook -i 54.165.59.142, -u ubuntu ../ansible/openvpn.yml --private-key ssh/openvpn-key-private --extra-vars="SERVER_IP=54.165.59.142"

}

# Create route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Public Route Table openvpn"
  }
}

#  Assosiate route table with subnet
resource "aws_route_table_association" "public_rt" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Create Security group
resource "aws_security_group" "allow_ssh_vpn" {
  name        = "allow_ssh_vpn"
  description = "Allow ssh and openvpn inbound traffic"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.ec2_ingress_ports
      content {
        description = ingress.value.description
        from_port   = ingress.value.port
        to_port     = ingress.value.port
        protocol    = ingress.value.protocol
        cidr_blocks = ["0.0.0.0/0"]
      }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh_openvpn"
  }
}

# Create network interface
resource "aws_network_interface" "openvpn-server-nic" {
  subnet_id       = aws_subnet.subnet.id
  security_groups = [aws_security_group.allow_ssh_vpn.id]
}


# IP of elastic_ip copied to a file ip.txt in local system
resource "local_file" "ip" {
    content  = aws_eip.elastic_ip.public_ip
    filename = "ip.txt"
}


output "elastic_ip" {
  value  = aws_eip.elastic_ip.public_ip
}
