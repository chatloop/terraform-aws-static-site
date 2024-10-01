data "aws_acm_certificate" "this" {
  provider = aws.us-east-1
  domain   = var.acm_certificate_name
}

data "aws_route53_zone" "this" {
  name = var.route53_zone_name
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.s3_bucket.s3_bucket_arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    dynamic "condition" {
      for_each = local.use_website_endpoint ? ["x"] : []

      content {
        test     = "StringEquals"
        variable = "aws:UserAgent"
        values   = [random_string.refer_secret[0].result]
      }
    }

    dynamic "condition" {
      for_each = local.use_website_endpoint == false ? ["x"] : []

      content {
        test     = "StringEquals"
        variable = "aws:SourceArn"
        values   = [module.cloudfront.cloudfront_distribution_arn]
      }
    }
  }
}
