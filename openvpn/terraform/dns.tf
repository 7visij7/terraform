
# resource "aws_route53_zone" "primary" {
#   name = var.domain
# }

# resource "aws_route53_record" "root" {
#   zone_id = aws_route53_zone.primary.zone_id
#   name    = "help.${var.domain}"
#   type    = "A"
#   records = [aws_instance.vpn_server.public_ip]
#   ttl = 300
# }

# output "dns_name" {
#     value = aws_route53_record.root.name
# }


# resource "aws_route53_record" "root" {
#   zone_id = aws_route53_zone.primary.zone_id
#   name    = var.domain
#   type    = "A"

#   alias {
#     name                   = aws_lb.load_balancer.dns_name
#     zone_id                = aws_lb.load_balancer.zone_id
#     evaluate_target_health = true
#   }
# }