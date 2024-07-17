resource "aws_lambda_function" "transcribe-function-715" {
  function_name                  = "transcribe-function-715"
  role                           = aws_iam_role.transcribe-lambda-role.arn
  handler                        = "transcribe.main.lambda_handler"
  runtime                        = "python3.10"
  timeout                        = 10
  memory_size                    = 500                                                    
  s3_bucket                      = aws_s3_bucket.transcriber-deployment-package-bucket-715.bucket 
  s3_key                         = aws_s3_object.transcribe-lambda-zip.key
  s3_object_version              = aws_s3_object.transcribe-lambda-zip.version_id              
}

resource "aws_lambda_function" "download-audio-function-715" {
  function_name                  = "download-audio-function-715"
  role                           = aws_iam_role.transcribe-lambda-role.arn
  handler                        = "download_audio.main.lambda_handler"
  runtime                        = "python3.10"
  timeout                        = 10
  memory_size                    = 500                                                    
  s3_bucket                      = aws_s3_bucket.transcriber-deployment-package-bucket-715.bucket 
  s3_key                         = aws_s3_object.transcribe-lambda-zip.key
  s3_object_version              = aws_s3_object.transcribe-lambda-zip.version_id              
}

resource "aws_lambda_function" "send-to-email-function-715" {
  function_name                  = "send-to-email-function-715"
  role                           = aws_iam_role.transcribe-lambda-role.arn
  handler                        = "send_to_email.main.lambda_handler"
  runtime                        = "python3.10"
  timeout                        = 10
  memory_size                    = 500                                                    
  s3_bucket                      = aws_s3_bucket.transcriber-deployment-package-bucket-715.bucket 
  s3_key                         = aws_s3_object.transcribe-lambda-zip.key
  s3_object_version              = aws_s3_object.transcribe-lambda-zip.version_id              
}