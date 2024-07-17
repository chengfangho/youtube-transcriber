resource "aws_s3_bucket" "transcriber-deployment-package-bucket-715" {
  bucket = "transcriber-deployment-package-bucket-715"
}

resource "aws_s3_bucket_versioning" "transcriber-deployment-package-bucket-715-versioning" {
  bucket = aws_s3_bucket.transcriber-deployment-package-bucket-715.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "transcribe-lambda-zip" {
  bucket = aws_s3_bucket.transcriber-deployment-package-bucket-715.bucket
  key = "lambda.zip"
}