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

resource "aws_s3_bucket_notification" "audio_upload_notifications" {
  bucket = aws_s3_bucket.audio-bucket-715.bucket

  lambda_function {
    lambda_function_arn = aws_lambda_function.transcribe-function-715.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".mp3"
  }

  lambda_function {
    lambda_function_arn = aws_lambda_function.send-to-email-function-715.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".srt"
  }

  depends_on = [
    aws_lambda_permission.allow_bucket-email,
    aws_lambda_permission.allow_bucket-transcribe
  ]
}