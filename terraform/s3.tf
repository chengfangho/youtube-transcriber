#bucket for storing lambda functions
resource "aws_s3_bucket" "transcriber-deployment-package-bucket-715" {
  bucket = "transcriber-deployment-package-bucket-715"
  force_destroy = true
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

resource "aws_s3_object" "audio-downloader-lambda-zip" {
  bucket = aws_s3_bucket.transcriber-deployment-package-bucket-715.bucket
  key = "audio_downloader_lambda.zip"
}

#bucket for storing audio
resource "aws_s3_bucket" "audio-bucket-715" {
  bucket = "audio-bucket-715"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "audio-bucket-715-versioning" {
  bucket = aws_s3_bucket.audio-bucket-715.bucket
  versioning_configuration {
    status = "Enabled"
  }
}