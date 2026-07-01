# =============================================================================
# Unit tests — tf-atom-s3-bucket-public-access-block-aws
#
# Uses a mock AWS provider so no real credentials or API calls are needed.
# Assertions target plan-KNOWN values only (tf-label context, input
# pass-throughs, resource count, static booleans). Computed attributes such
# as the resource `id`/`arn` are unknown under a mock provider and are NOT
# asserted on.
# =============================================================================

mock_provider "aws" {}

variables {
  # tf-label context (drives module.this.id => "eg-test-thing")
  namespace = "eg"
  stage     = "test"
  name      = "thing"

  # Module-specific required input
  bucket_id = "eg-test-thing-bucket"
}

# -----------------------------------------------------------------------------
# Enabled (default): the public access block is created and secure-by-default.
# -----------------------------------------------------------------------------
run "creates_when_enabled" {
  command = plan

  assert {
    condition     = output.enabled == true
    error_message = "Module should report enabled == true by default"
  }

  assert {
    condition     = length(aws_s3_bucket_public_access_block.this) == 1
    error_message = "Exactly one public access block should be created when enabled"
  }

  assert {
    condition     = output.bucket_id == "eg-test-thing-bucket"
    error_message = "bucket_id output should pass through the provided bucket_id"
  }
}

# -----------------------------------------------------------------------------
# Secure-by-default: all four public-access controls default to true.
# -----------------------------------------------------------------------------
run "secure_by_default" {
  command = plan

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

# -----------------------------------------------------------------------------
# Selective override: individual controls can be toggled off.
# -----------------------------------------------------------------------------
run "allows_selective_override" {
  command = plan

  variables {
    block_public_policy     = false
    restrict_public_buckets = false
  }

  assert {
    condition     = aws_s3_bucket_public_access_block.this[0].block_public_policy == false
    error_message = "block_public_policy should be overridable to false"
  }

  assert {
    condition     = aws_s3_bucket_public_access_block.this[0].restrict_public_buckets == false
    error_message = "restrict_public_buckets should be overridable to false"
  }
}

# -----------------------------------------------------------------------------
# Disabled: no resources are created and id/bucket_id outputs are null.
# -----------------------------------------------------------------------------
run "disabled_creates_nothing" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition     = length(aws_s3_bucket_public_access_block.this) == 0
    error_message = "No public access block should be created when enabled = false"
  }

  assert {
    condition     = output.enabled == false
    error_message = "enabled output should be false when disabled"
  }

  assert {
    condition     = output.id == null
    error_message = "id output should be null when the module is disabled"
  }

  assert {
    condition     = output.bucket_id == null
    error_message = "bucket_id output should be null when the module is disabled"
  }
}
