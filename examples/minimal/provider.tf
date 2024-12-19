provider "aws" {
  region = "eu-west-2"

  allowed_account_ids = var.allowed_account_ids
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"

  allowed_account_ids = var.allowed_account_ids
}
