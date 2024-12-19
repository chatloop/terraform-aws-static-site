# Terraform AWS Static Site

This module provisions a static website using CloudFront+S3.
Optionally, the website can be protected with OpenID Connect.

## Usage

<!-- markdownlint-disable -->
<!-- x-release-please-start-version -->
```hcl
module "static_site" {
  source = "github.com/chatloop/terraform-aws-static-site?ref=v1.1.0"

  providers = {
    aws.us-east-1 = aws.us-east-1
  }

  acm_certificate_name = "example.com"
  domain_name          = "static-site-test.example.com"
  name                 = "terraform-aws-static-site"
  route53_zone_name    = "example.com"
}
```
<!-- x-release-please-end -->
<!-- markdownlint-restore -->

<!-- markdownlint-disable -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |
| <a name="provider_aws.us-east-1"></a> [aws.us-east-1](#provider\_aws.us-east-1) | ~> 5.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_authorizer"></a> [authorizer](#module\_authorizer) | github.com/chatloop/terraform-aws-cloudfront-auth | 695c3eb440a90e2441a006f9d091e6f73218fb0d |
| <a name="module_cloudfront"></a> [cloudfront](#module\_cloudfront) | github.com/terraform-aws-modules/terraform-aws-cloudfront | a0f0506106a4c8815c1c32596e327763acbef2c2 |
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | github.com/terraform-aws-modules/terraform-aws-s3-bucket | 8a0b697adfbc673e6135c70246cff7f8052ad95a |
| <a name="module_website_configuration"></a> [website\_configuration](#module\_website\_configuration) | github.com/terraform-aws-modules/terraform-aws-lambda | 1d122404c2a3834ce39a7c5a319a3e754d5b0c29 |

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [random_string.refer_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_acm_certificate.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_iam_policy_document.s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_policy_cloudfront_oac](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_policy_website_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_certificate_arn"></a> [acm\_certificate\_arn](#input\_acm\_certificate\_arn) | n/a | `string` | `null` | no |
| <a name="input_acm_certificate_name"></a> [acm\_certificate\_name](#input\_acm\_certificate\_name) | n/a | `string` | `null` | no |
| <a name="input_aliases"></a> [aliases](#input\_aliases) | n/a | `list(string)` | `[]` | no |
| <a name="input_authorizer"></a> [authorizer](#input\_authorizer) | n/a | <pre>object({<br/>    function_name = optional(string)<br/>    tenant        = string<br/>    client_id     = string<br/>    client_secret = string<br/>    redirect_uri  = optional(string)<br/><br/>    session_duration = optional(number)<br/><br/>    trailing_slash_redirects_enabled = optional(bool)<br/><br/>    simple_urls_enabled = optional(bool)<br/>  })</pre> | `null` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | n/a | `string` | `null` | no |
| <a name="input_comment"></a> [comment](#input\_comment) | n/a | `string` | `null` | no |
| <a name="input_custom_error_response"></a> [custom\_error\_response](#input\_custom\_error\_response) | n/a | <pre>list(object({<br/>    error_code            = number<br/>    response_code         = number<br/>    response_page_path    = optional(string)<br/>    error_caching_min_ttl = optional(number)<br/>  }))</pre> | `[]` | no |
| <a name="input_default_cache_behavior"></a> [default\_cache\_behavior](#input\_default\_cache\_behavior) | n/a | <pre>object({<br/>    allowed_methods              = optional(list(string), ["GET", "HEAD", "OPTIONS"])<br/>    cached_methods               = optional(list(string), ["GET", "HEAD", "OPTIONS"])<br/>    compress                     = optional(bool, true)<br/>    cache_policy_id              = optional(string)<br/>    cache_policy_name            = optional(string, "Managed-CachingOptimized")<br/>    origin_request_policy_id     = optional(string)<br/>    origin_request_policy_name   = optional(string, "Managed-CORS-S3Origin")<br/>    response_headers_policy_id   = optional(string)<br/>    response_headers_policy_name = optional(string, "Managed-SecurityHeadersPolicy")<br/>    target_origin_id             = optional(string)<br/>    use_authorizer               = optional(bool, true)<br/>    viewer_protocol_policy       = optional(string, "redirect-to-https")<br/>  })</pre> | `{}` | no |
| <a name="input_default_root_object"></a> [default\_root\_object](#input\_default\_root\_object) | n/a | `string` | `"index.html"` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | n/a | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_ordered_cache_behavior"></a> [ordered\_cache\_behavior](#input\_ordered\_cache\_behavior) | n/a | <pre>list(object({<br/>    allowed_methods              = optional(list(string), ["GET", "HEAD", "OPTIONS"])<br/>    cached_methods               = optional(list(string), ["GET", "HEAD", "OPTIONS"])<br/>    compress                     = optional(bool, true)<br/>    cache_policy_id              = optional(string)<br/>    cache_policy_name            = optional(string, "Managed-CachingOptimized")<br/>    origin_request_policy_id     = optional(string)<br/>    origin_request_policy_name   = optional(string, "Managed-CORS-S3Origin")<br/>    path_pattern                 = string<br/>    response_headers_policy_id   = optional(string)<br/>    response_headers_policy_name = optional(string, "Managed-SecurityHeadersPolicy")<br/>    target_origin_id             = optional(string)<br/>    use_authorizer               = optional(bool, true)<br/>    viewer_protocol_policy       = optional(string, "redirect-to-https")<br/>  }))</pre> | `[]` | no |
| <a name="input_route53_zone_name"></a> [route53\_zone\_name](#input\_route53\_zone\_name) | n/a | `string` | `null` | no |
| <a name="input_website_configuration"></a> [website\_configuration](#input\_website\_configuration) | n/a | <pre>object({<br/>    index_document = optional(string)<br/><br/>    redirect_all_requests_to = optional(object({<br/>      host_name = string<br/>      protocol  = optional(string)<br/>    }))<br/>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_domain_name"></a> [cloudfront\_domain\_name](#output\_cloudfront\_domain\_name) | n/a |
<!-- END_TF_DOCS -->
<!-- markdownlint-restore -->
