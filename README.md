# tf-atom-s3-bucket-public-access-block-aws

[![CI](https://github.com/PlatformStackPulse/tf-atom-s3-bucket-public-access-block-aws/actions/workflows/ci.yml/badge.svg)](https://github.com/PlatformStackPulse/tf-atom-s3-bucket-public-access-block-aws/actions/workflows/ci.yml)
[![Release](https://github.com/PlatformStackPulse/tf-atom-s3-bucket-public-access-block-aws/actions/workflows/auto-release.yml/badge.svg)](https://github.com/PlatformStackPulse/tf-atom-s3-bucket-public-access-block-aws/actions/workflows/auto-release.yml)

---

## Purpose

Configures the S3 bucket public access block settings, preventing any public access to the bucket by default. All four public access controls default to `true` (deny all public access).

## Architecture

```
┌─────────────────────────────────────────────────┐
│           Molecule Layer                        │
│  ┌──────────────┐    ┌────────────────────┐    │
│  │ s3-bucket    │───▶│ THIS MODULE        │    │
│  │ (bucket_id)  │    │ public-access-block│    │
│  └──────────────┘    │ (blocks public)    │    │
│                      └────────────────────┘    │
└─────────────────────────────────────────────────┘
```

## Scope

| In Scope | Out of Scope |
|----------|--------------|
| `aws_s3_bucket_public_access_block` resource | Bucket creation (→ `tf-atom-s3-bucket-aws`) |
| All 4 public access controls | Bucket policy (→ `tf-atom-s3-bucket-policy-aws`) |
| Conditional creation (`enabled`) | Encryption (→ `tf-atom-s3-bucket-encryption-aws`) |
| Selective override of individual settings | ACL management |

## Features

- **Single-resource atom** — one `aws_s3_bucket_public_access_block`
- **Secure by default** — all four controls default to `true` (block everything)
- **Selective override** — each control can be individually toggled
- **Context propagation** — inherits tf-label context
- **Conditional creation** — `enabled = false` creates zero resources
- **Tested** — unit tests for defaults, disabled, and selective override

## Usage

```hcl
module "public_access_block" {
  source = "github.com/PlatformStackPulse/tf-atom-s3-bucket-public-access-block-aws?ref=v1.0.0"

  context   = module.this.context
  bucket_id = module.bucket.bucket_id

  # All default to true — override only if needed
  # block_public_acls       = true
  # block_public_policy     = true
  # ignore_public_acls      = true
  # restrict_public_buckets = true
}
```

## Module Documentation

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
