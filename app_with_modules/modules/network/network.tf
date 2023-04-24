# Create Security group frontend
resource "aws_security_group" "sg_frontend" {
  name = "${var.app_name}-${var.environment_name}-frontend-security-group"
  description = "Allow inbound traffic for frontend"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.frontend_ingress_ports
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
    Name = "allow_webserver traffic frontend  ${var.app_name}-${var.environment_name}"
  }
}

# Create Security group backend
resource "aws_security_group" "sg_backend" {
  name = "${var.app_name}-${var.environment_name}-backend-security-group"
  description = "Allow inbound traffic for backend"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.backend_ingress_ports
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
    cidr_blocks      = aws_subnet.public_subnets[*].cidr_block
    ipv6_cidr_blocks = ["::/0"]
  }

 tags = {
    Name = "allow_backend traffic backend ${var.environment_name}"
  }
}

# Create Security group db
resource "aws_security_group" "sg_db" {
  name = "${var.app_name}-${var.environment_name}-db-security-group"
  description = "Allow inbound traffic for db"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.db_ingress_ports
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
    cidr_blocks      = aws_subnet.private_subnets[*].cidr_block
    ipv6_cidr_blocks = ["::/0"]
  }

 tags = {
    Name = "allow traffic db ${var.app_name}-${var.environment_name}"
  }
}


# Create VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_network[var.environment_name]

  tags = {
    Name = "${var.app_name}-${var.environment_name}"
  }
}

# Create public Subnet
resource "aws_subnet" "public_subnets" {
  vpc_id = aws_vpc.main.id
  count = var.copy_of_application
  cidr_block = "${cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + 1 )}"
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    "Name" = "${var.app_name}-${var.environment_name}-public-${count.index}"
  }
}

# Create private Subnet
resource "aws_subnet" "private_subnets" {
  count = var.copy_of_application 
  vpc_id = aws_vpc.main.id
  cidr_block = "${cidrsubnet(aws_vpc.main.cidr_block, 8, var.copy_of_application + count.index +1)}"
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    "Name" = "${var.app_name}-${var.environment_name}-private-${count.index}"
  }
}

# Create DB Subnet
resource "aws_subnet" "db_subnets" {
  count = (var.copy_of_application == 1 ? 2 : var.copy_of_application)
  vpc_id = aws_vpc.main.id
  cidr_block = "${cidrsubnet(aws_vpc.main.cidr_block, 8, var.copy_of_application * 2 + count.index +1)}"
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]

  tags = {
    "Name" = "${var.app_name}-${var.environment_name}-db-${count.index}"
  }
}

# Create DB Subnet group
resource "aws_db_subnet_group" "group_db_subnets" {
  name = "${var.app_name}-${var.environment_name}"
  subnet_ids = aws_subnet.db_subnets.*.id

  tags = {
    "Name" = "${var.app_name}-${var.environment_name}-db-group"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {   
      Name = "${var.app_name}-${var.environment_name}-IG"
  }
}

# Create route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.app_name}-${var.environment_name}"
  }
}

#  Assosiate route table with subnet
resource "aws_route_table_association" "public_rt" {
  # for_each       = { for x in aws_subnet.private_subnets[*]: x.id => x }
  count = var.copy_of_application 
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}


