data "aws_acm_certificate" "this" {
  provider = aws.us-east-1
  domain   = var.acm_certificate_name
}

data "aws_route53_zone" "this" {
  name = var.route53_zone_name
}

data "aws_iam_policy_document" "s3_policy_cloudfront_oac" {
  count = local.use_website_endpoint == false ? 1 : 0

  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.s3_bucket.s3_bucket_arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [module.cloudfront.cloudfront_distribution_arn]
    }
  }
}

data "aws_iam_policy_document" "s3_policy_website_endpoint" {
  count = local.use_website_endpoint ? 1 : 0

  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.s3_bucket.s3_bucket_arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:UserAgent"
      values   = [random_string.refer_secret[0].result]
    }
  }
}

data "aws_iam_policy_document" "s3_policy" {
  source_policy_documents = compact([
    try(data.aws_iam_policy_document.s3_policy_cloudfront_oac[0].json, null),
    try(data.aws_iam_policy_document.s3_policy_website_endpoint[0].json, null),
  ])
}
