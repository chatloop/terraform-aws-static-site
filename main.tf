locals {
  create_r53_records   = var.route53_zone_name != null
  s3_origin_id         = "s3"
  use_authorizer       = var.authorizer != null
  use_website_endpoint = var.website_configuration != null
}

resource "random_string" "refer_secret" {
  count   = local.use_website_endpoint ? 1 : 0
  length  = 16
  special = false
}

module "s3_bucket" {
  source = "github.com/terraform-aws-modules/terraform-aws-s3-bucket?ref=8a0b697adfbc673e6135c70246cff7f8052ad95a" # v4.1.2

  bucket = coalesce(var.bucket_name, var.name)

  attach_public_policy    = true
  block_public_acls       = local.use_website_endpoint == false
  block_public_policy     = local.use_website_endpoint == false
  ignore_public_acls      = local.use_website_endpoint == false
  restrict_public_buckets = local.use_website_endpoint == false

  attach_policy = true
  policy        = data.aws_iam_policy_document.s3_policy.json

  server_side_encryption_configuration = {
    rule = {
      bucket_key_enabled = true

      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  website = {
    for key, value in try(coalesce(var.website_configuration), {}) : key => value
    if value != null
  }
}

module "authorizer" {
  source = "github.com/chatloop/terraform-aws-cloudfront-auth?ref=695c3eb440a90e2441a006f9d091e6f73218fb0d" # v0.2.0
  count  = local.use_authorizer ? 1 : 0

  providers = {
    aws = aws.us-east-1
  }

  function_name = coalesce(var.authorizer.function_name, "${var.name}-oidc-auth")
  tenant        = var.authorizer.tenant
  client_id     = var.authorizer.client_id
  client_secret = var.authorizer.client_secret
  redirect_uri  = coalesce(var.authorizer.redirect_uri, "https://${var.domain_name}/_callback")

  session_duration = coalesce(var.authorizer.session_duration, 24)

  trailing_slash_redirects_enabled = coalesce(var.authorizer.trailing_slash_redirects_enabled, true)

  simple_urls_enabled = coalesce(var.authorizer.simple_urls_enabled, true)
}

# This module prevents S3 from ensuring trailing slashes exists on uris
# The S3 redirect is problematic with query strings as the redirect strips them
module "website_configuration" {
  source = "github.com/terraform-aws-modules/terraform-aws-lambda?ref=1d122404c2a3834ce39a7c5a319a3e754d5b0c29" # v7.8.1
  count  = local.use_website_endpoint ? 1 : 0

  providers = {
    aws = aws.us-east-1
  }

  function_name = "${var.name}-website-configuration"
  description   = "Website Configuration powered by Lambda@Edge"

  handler = "index.handler"
  runtime = "nodejs20.x"

  lambda_at_edge = true

  cloudwatch_logs_retention_in_days = 30
  recreate_missing_package          = false

  source_path = "${path.module}/src/website-configuration"
}

module "cloudfront" {
  source = "github.com/terraform-aws-modules/terraform-aws-cloudfront?ref=a0f0506106a4c8815c1c32596e327763acbef2c2" # v3.4.0

  aliases             = concat([var.domain_name], var.aliases)
  comment             = var.comment
  default_root_object = var.default_root_object
  http_version        = "http2and3"
  is_ipv6_enabled     = true
  price_class         = "PriceClass_100"

  # The OAC is not used when using website endpoints as these can't be restricted
  create_origin_access_control = local.use_website_endpoint == false

  origin_access_control = {
    (var.name) = {
      description      = "OAC to restrict access to S3"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }

  origin = {
    (local.s3_origin_id) = merge(
      {
        domain_name = local.use_website_endpoint == false ? module.s3_bucket.s3_bucket_bucket_regional_domain_name : module.s3_bucket.s3_bucket_website_endpoint

        origin_access_control = var.name
      },
      local.use_website_endpoint == false ? {} : {
        custom_header = [{
          name  = "User-Agent"
          value = random_string.refer_secret[0].result
        }]
      },
      local.use_website_endpoint == false ? {} : {
        custom_origin_config = {
          http_port              = 80
          https_port             = 443
          origin_ssl_protocols   = ["TLSv1.2"]
          origin_protocol_policy = "http-only"
        }
      }
    )
  }

  default_cache_behavior = {
    for k, v in merge(var.default_cache_behavior, {
      target_origin_id = coalesce(var.default_cache_behavior.target_origin_id, local.s3_origin_id)

      use_forwarded_values = false # this is a legacy CloudFront feature and policies should be used instead

      lambda_function_association = (merge(
        local.use_authorizer == false || var.default_cache_behavior.use_authorizer == false ? {} : {
          viewer-request = {
            lambda_arn = module.authorizer[0].lambda_qualified_arn
          }
        },
        local.use_website_endpoint == false ? {} : {
          origin-request = {
            lambda_arn = module.website_configuration[0].lambda_function_qualified_arn
          }
        }
      ))
    }) : k => v if v != null
  }

  ordered_cache_behavior = [
    for behavior in var.ordered_cache_behavior : {
      for k, v in merge(behavior, {
        target_origin_id = coalesce(behavior.target_origin_id, local.s3_origin_id)

        use_forwarded_values = false # this is a legacy CloudFront feature and policies should be used instead

        lambda_function_association = (merge(
          local.use_authorizer == false || behavior.use_authorizer == false ? {} : {
            viewer-request = {
              lambda_arn = module.authorizer[0].lambda_qualified_arn
            }
          },
          local.use_website_endpoint == false ? {} : {
            origin-request = {
              lambda_arn = module.website_configuration[0].lambda_function_qualified_arn
            }
          }
        ))
      }) : k => v if v != null
    }
  ]

  # [{}] is an odd default value but this avoids a bug in the module:
  # https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/121#issuecomment-1852172451
  custom_error_response = length(var.custom_error_response) > 0 ? var.custom_error_response : [{}]

  viewer_certificate = {
    acm_certificate_arn      = var.acm_certificate_arn != null ? var.acm_certificate_arn : try(data.aws_acm_certificate.this[0].arn, null)
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
}

resource "aws_route53_record" "this" {
  for_each = toset(local.create_r53_records ? concat([var.domain_name], var.aliases) : [])

  zone_id = data.aws_route53_zone.this[0].id

  name = each.key
  type = "A"

  alias {
    name                   = module.cloudfront.cloudfront_distribution_domain_name
    zone_id                = module.cloudfront.cloudfront_distribution_hosted_zone_id
    evaluate_target_health = false
  }
}
