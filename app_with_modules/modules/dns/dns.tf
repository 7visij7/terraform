resource "aws_route53_zone" "primary" {
  name  = var.domain
}

resource "aws_route53_record" "root" {
  count        = var.copy_of_application > 1 ? 1 : 0 
  zone_id      = aws_route53_zone.primary.zone_id
  name         = "${var.domain}"
  type         = "A"
 
  alias {
    name                   = var.load_balancer_dns_name
    zone_id                = var.load_balancer_zone_id
    evaluate_target_health = true
  }
}


resource "aws_route53_record" "secondary" {
  count   = var.copy_of_application > 1 ? 0 : 1 
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.domain
  type    = "A"
  ttl     = "300"
  records = [var.public_ip[0]]
}
