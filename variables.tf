variable "acm_certificate_name" {
  type = string
}

variable "authorizer" {
  type = object({
    function_name = optional(string)
    tenant        = string
    client_id     = string
    client_secret = string
    redirect_uri  = optional(string)

    session_duration = optional(number)

    trailing_slash_redirects_enabled = optional(bool)

    simple_urls_enabled = optional(bool)
  })

  default = null
}

variable "bucket_name" {
  type    = string
  default = null
}

variable "comment" {
  type    = string
  default = null
}

variable "custom_error_response" {
  type = list(object({
    error_code            = number
    response_code         = number
    response_page_path    = optional(string)
    error_caching_min_ttl = optional(number)
  }))

  default = []
}

variable "default_cache_behavior" {
  type = object({
    allowed_methods              = optional(list(string), ["GET", "HEAD", "OPTIONS"])
    cached_methods               = optional(list(string), ["GET", "HEAD", "OPTIONS"])
    compress                     = optional(bool, true)
    cache_policy_id              = optional(string)
    cache_policy_name            = optional(string, "Managed-CachingOptimized")
    origin_request_policy_id     = optional(string)
    origin_request_policy_name   = optional(string, "Managed-CORS-S3Origin")
    response_headers_policy_id   = optional(string)
    response_headers_policy_name = optional(string, "Managed-SecurityHeadersPolicy")
    target_origin_id             = optional(string)
    viewer_protocol_policy       = optional(string, "redirect-to-https")
  })

  default = {}
}

variable "default_root_object" {
  type    = string
  default = "index.html"
}

variable "domain_name" {
  type = string
}

variable "name" {
  type = string
}

variable "ordered_cache_behavior" {
  type = list(object({
    allowed_methods              = optional(list(string), ["GET", "HEAD", "OPTIONS"])
    cached_methods               = optional(list(string), ["GET", "HEAD", "OPTIONS"])
    compress                     = optional(bool, true)
    cache_policy_id              = optional(string)
    cache_policy_name            = optional(string, "Managed-CachingOptimized")
    origin_request_policy_id     = optional(string)
    origin_request_policy_name   = optional(string, "Managed-CORS-S3Origin")
    path_pattern                 = string
    response_headers_policy_id   = optional(string)
    response_headers_policy_name = optional(string, "Managed-SecurityHeadersPolicy")
    target_origin_id             = optional(string)
    viewer_protocol_policy       = optional(string, "redirect-to-https")
  }))

  default = []
}

variable "route53_zone_name" {
  type = string
}

variable "website_configuration" {
  type = object({
    index_document = string
  })

  default = null
}
