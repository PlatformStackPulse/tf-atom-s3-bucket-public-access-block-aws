provider "aws" {
  region = "eu-west-2"
}

module "s3_public_access_block" {
  source = "../../"

  namespace   = "psp"
  environment = "dev"
  name        = "assets"

  bucket_id = "psp-dev-assets"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "id" {
  value = module.s3_public_access_block.id
}
