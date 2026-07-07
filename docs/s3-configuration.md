# Amazon S3 Configuration for Thanos

## Bucket Configuration

Create an S3 bucket for Thanos TSDB blocks. Use versioning and server-side encryption.

## Required Fields in objstore.yml

- type: object storage backend type, usually s3
- config.bucket: target S3 bucket name
- config.endpoint: S3 endpoint or AWS endpoint
- config.region: AWS region
- config.access_key: IAM access key
- config.secret_key: IAM secret key
- config.insecure: set to false for HTTPS
- config.signature_version2: leave false for modern AWS S3
- config.part_size: upload chunk size for block files
- config.sse_config.type: encryption type such as SSE-S3

## IAM Policy

The example Terraform configuration creates an IAM user with permission to put, get, list, and delete objects in the target bucket.

## Bucket Policy

Apply a bucket policy that allows the IAM user to write and read objects. For production, prefer least privilege and separate roles where possible.
