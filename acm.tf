
resource "aws_acm_certificate" "gs_dev_acm" {
  domain_name       = "build.growthservice.co"
  validation_method = "DNS"

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_acm_certificate_validation" "gs_dev_acm" {
  certificate_arn         = aws_acm_certificate.gs_dev_acm.arn
  validation_record_fqdns = [for record in aws_route53_record.gs_dev_acm : record.fqdn]
}
