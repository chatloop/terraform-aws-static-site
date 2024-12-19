variable "acm_certificate_name" {
  type = string
}

variable "allowed_account_ids" {
  type = list(string)
}

variable "domain_name" {
  type = string
}

variable "route53_zone_name" {
  type = string
}
