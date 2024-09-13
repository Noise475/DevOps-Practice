output "bucket_arn" {
  value = { for env, bucket in aws_s3_bucket.bucket_env_example : env => bucket.arn }
}
