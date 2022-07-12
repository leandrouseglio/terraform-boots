terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }

  required_version = "~> 1.0"
}
# Build an S3 bucket to store TF state
resource "aws_s3_bucket" "state_bucket" {
  bucket = "${var.s3_tfstate_bucket}-${var.aws_id}-${var.region}"

  tags = {
    Terraform = "true"
  }
}

# Tells AWS to encrypt the S3 bucket at rest by default
resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.state_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}