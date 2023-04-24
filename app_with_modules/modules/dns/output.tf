
output "dns_name" {
  value = try("${aws_route53_record.root[0].fqdn}", "${aws_route53_record.secondary[0].fqdn}")
}
