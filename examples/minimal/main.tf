module "static_site" {
  source = "../.."

  providers = {
    aws.us-east-1 = aws.us-east-1
  }

  acm_certificate_name = var.acm_certificate_name
  domain_name          = var.domain_name
  name                 = "terraform-aws-static-site"
  route53_zone_name    = var.route53_zone_name

  website_configuration = {
    index_document = "index.html"
  }
}
