
# Get availability zones
data "aws_availability_zones" "available_zones" {
  state = "available"
}
