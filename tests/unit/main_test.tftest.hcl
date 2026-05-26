mock_provider "aws" {}

run "blocks_all_public_access_by_default" {
  variables {
    name        = "test"
    environment = "dev"
    namespace   = "unit"
    bucket_id   = "my-test-bucket"
  }

  assert {
    condition     = aws_s3_bucket_public_access_block.this[0].block_public_acls == true
    error_message = "block_public_acls should default to true"
  }

  assert {
    condition     = aws_s3_bucket_public_access_block.this[0].block_public_policy == true
    error_message = "block_public_policy should default to true"
  }

  assert {
    condition     = aws_s3_bucket_public_access_block.this[0].ignore_public_acls == true
    error_message = "ignore_public_acls should default to true"
  }

  assert {
    condition     = aws_s3_bucket_public_access_block.this[0].restrict_public_buckets == true
    error_message = "restrict_public_buckets should default to true"
  }
}

run "creates_nothing_when_disabled" {
  variables {
    name        = "test"
    environment = "dev"
    namespace   = "unit"
    enabled     = false
    bucket_id   = "my-test-bucket"
  }

  assert {
    condition     = length(aws_s3_bucket_public_access_block.this) == 0
    error_message = "No resource should be created when disabled"
  }
}

run "allows_selective_override" {
  variables {
    name                    = "test"
    environment             = "dev"
    namespace               = "unit"
    bucket_id               = "my-test-bucket"
    block_public_acls       = true
    block_public_policy     = false
    ignore_public_acls      = true
    restrict_public_buckets = false
  }

  assert {
    condition     = aws_s3_bucket_public_access_block.this[0].block_public_policy == false
    error_message = "block_public_policy should be overridable"
  }

  assert {
    condition     = aws_s3_bucket_public_access_block.this[0].restrict_public_buckets == false
    error_message = "restrict_public_buckets should be overridable"
  }
}
