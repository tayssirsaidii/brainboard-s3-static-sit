resource "aws_s3_bucket" "tay-static-site-2026" {
  tags   = merge(var.tags, {})
  region = "us-east-1"
}

resource "aws_s3_bucket_website_configuration" "s3_bucket_website_configuration" {
  region = "us-east-1"
  bucket = aws_s3_bucket.tay-static-site-2026.bucket

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
  restrict_public_buckets = false
  region                  = "us-east-1"
  ignore_public_acls      = false
  bucket                  = aws_s3_bucket.tay-static-site-2026.id
  block_public_policy     = false
  block_public_acls       = false
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  region = "us-east-1"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "PublicReadGetObject"
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.tay-static-site-2026.arn}/*"
    }]
  })
  bucket = aws_s3_bucket.tay-static-site-2026.bucket

  depends_on = [
    aws_s3_bucket_public_access_block.s3_bucket_public_access_block,
  ]
}

resource "aws_s3_object" "s3_object" {
  tags         = merge(var.tags, {})
  region       = "us-east-1"
  key          = "index.html"
  content_type = "text/html"
  content      = "<html><body><h1>Tay's portfolio</h1><p>Hosted on AWS S3, built with Brainboard and Terraform.</p></body></html>"
  bucket       = aws_s3_bucket.tay-static-site-2026.id
}

