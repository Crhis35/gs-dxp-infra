#resource "aws_route53_zone" "growth_dev" {
#  name = "growthservice.co"
# tags = var.tags
#}

resource "aws_route53_record" "jenkins_record" {
  allow_overwrite = true
  name            = "build.growthservice.co"
  type            = "A"


  zone_id = var.zone_id
  alias {
    name                   = aws_lb.lb.dns_name
    evaluate_target_health = false
    zone_id                = aws_lb.lb.zone_id
  }
}
resource "aws_route53_record" "gs_dev_acm" {
  for_each = {
    for dvo in aws_acm_certificate.gs_dev_acm.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.zone_id
}
