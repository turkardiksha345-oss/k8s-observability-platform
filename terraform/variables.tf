variable "aws_region" {
  description = "AWS region where the S3 bucket will be created"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Globally unique S3 bucket name for Thanos object storage"
  type        = string
  default     = "thanos-metrics-prod-bucket-1"
}
