terraform {
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "metrics" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

resource "aws_s3_bucket_versioning" "metrics" {
  bucket = aws_s3_bucket.metrics.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "metrics" {
  bucket = aws_s3_bucket.metrics.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_iam_user" "thanos" {
  name = "thanos-s3-writer"
}

resource "aws_iam_access_key" "thanos" {
  user = aws_iam_user.thanos.name
}

resource "aws_iam_user_policy" "thanos_s3" {
  name = "thanos-s3-write"
  user = aws_iam_user.thanos.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ]
        Resource = [
          aws_s3_bucket.metrics.arn,
          "${aws_s3_bucket.metrics.arn}/*"
        ]
      }
    ]
  })
}

output "bucket_name" {
  value = aws_s3_bucket.metrics.bucket
}

output "access_key_id" {
  value = aws_iam_access_key.thanos.id
}

output "secret_access_key" {
  value     = aws_iam_access_key.thanos.secret
  sensitive = true
}
