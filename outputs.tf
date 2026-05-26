output "enabled" {
  description = "Whether the module is enabled."
  value       = local.enabled
}

output "id" {
  description = "ID of the public access block configuration"
  value       = try(aws_s3_bucket_public_access_block.this[0].id, null)
}

output "bucket_id" {
  description = "ID of the bucket the public access block is attached to"
  value       = try(aws_s3_bucket_public_access_block.this[0].bucket, null)
}
