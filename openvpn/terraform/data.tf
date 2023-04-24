# Get latest AMI of Ubuntu 20.04
data "aws_ami" "latest_amazon_ubuntu" {
    most_recent = true
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
    owners = ["099720109477"] # Canonical
}

# Get availability zones
data "aws_availability_zones" "available" {
  state = "available"
}
