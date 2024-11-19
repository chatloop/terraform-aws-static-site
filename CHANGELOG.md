# Changelog

## [1.0.0](https://github.com/chatloop/terraform-aws-static-site/compare/v0.3.0...v1.0.0) (2024-11-19)


### ⚠ BREAKING CHANGES

* optionally create route53 records ([#16](https://github.com/chatloop/terraform-aws-static-site/issues/16))

### Features

* added acm_certificate_arn input variable ([#17](https://github.com/chatloop/terraform-aws-static-site/issues/17)) ([417f8ce](https://github.com/chatloop/terraform-aws-static-site/commit/417f8ceaf294e57e955e702ccc91cee05abebe90))
* added additional website_configuration parameters ([#19](https://github.com/chatloop/terraform-aws-static-site/issues/19)) ([2d780b2](https://github.com/chatloop/terraform-aws-static-site/commit/2d780b2afd5b3f140975df15a1bb978db3333771))
* added cloudfront_domain_name output ([#18](https://github.com/chatloop/terraform-aws-static-site/issues/18)) ([d307a49](https://github.com/chatloop/terraform-aws-static-site/commit/d307a49d444ead4bfe4cc4b6ae0611394ed420ac))
* optionally create route53 records ([#16](https://github.com/chatloop/terraform-aws-static-site/issues/16)) ([e48a1e1](https://github.com/chatloop/terraform-aws-static-site/commit/e48a1e1f7db34d7ebb3e38d22506c34aa2ca8eba))


### Continuous Integration

* fix terraform-docs and exclude changelog from pre-commit ([#20](https://github.com/chatloop/terraform-aws-static-site/issues/20)) ([66c2c5b](https://github.com/chatloop/terraform-aws-static-site/commit/66c2c5b42e5c4f7c55e49dce232a6b0babae583b))
* fix typo in release-please reverts type ([#14](https://github.com/chatloop/terraform-aws-static-site/issues/14)) ([5f3bb76](https://github.com/chatloop/terraform-aws-static-site/commit/5f3bb762519085726b84895386c7b68d75686b78))

## [0.3.0](https://github.com/chatloop/terraform-aws-static-site/compare/v0.2.3...v0.3.0) (2024-10-04)


### Features

* allow disabling the authorizer per behavior ([#12](https://github.com/chatloop/terraform-aws-static-site/issues/12)) ([398c8e2](https://github.com/chatloop/terraform-aws-static-site/commit/398c8e2ab91fd0b48e6f8c01e610ca44087ea3cc))

## [0.2.3](https://github.com/chatloop/terraform-aws-static-site/compare/v0.2.2...v0.2.3) (2024-10-04)


### Bug Fixes

* typo in s3 policy ([#10](https://github.com/chatloop/terraform-aws-static-site/issues/10)) ([deb6260](https://github.com/chatloop/terraform-aws-static-site/commit/deb6260b4a87353b260ebbaa26a42e74ac77a68b))

## [0.2.2](https://github.com/chatloop/terraform-aws-static-site/compare/v0.2.1...v0.2.2) (2024-10-04)


### Bug Fixes

* s3 policy set incorrectly when using website configuration ([#8](https://github.com/chatloop/terraform-aws-static-site/issues/8)) ([e745eb7](https://github.com/chatloop/terraform-aws-static-site/commit/e745eb71743a9b7b9246c8ce64d2cc4e8d91cb3f))

## [0.2.1](https://github.com/chatloop/terraform-aws-static-site/compare/v0.2.0...v0.2.1) (2024-10-04)


### Bug Fixes

* set s3 bucket public when using website configuration ([#6](https://github.com/chatloop/terraform-aws-static-site/issues/6)) ([6fab942](https://github.com/chatloop/terraform-aws-static-site/commit/6fab942840c19493dcdc1166b4419c78a13f1b68))

## [0.2.0](https://github.com/chatloop/terraform-aws-static-site/compare/v0.1.0...v0.2.0) (2024-10-02)


### Features

* added configurable default_root_object ([#4](https://github.com/chatloop/terraform-aws-static-site/issues/4)) ([c08a0f8](https://github.com/chatloop/terraform-aws-static-site/commit/c08a0f8fe61c854fc1e62a9bdcdd7e07946e185f))

## 0.1.0 (2024-10-01)


### Features

* initial commit ([a82a3ba](https://github.com/chatloop/terraform-aws-static-site/commit/a82a3ba9a9c6d69b33c363b61cd9202ffb7c2af0))
