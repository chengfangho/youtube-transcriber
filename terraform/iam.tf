resource "aws_iam_role" "transcribe-lambda-role" {
    name   = "transcribe-lambda-role"
    assume_role_policy = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Principal": {
        "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
    }
    ]
    }
    EOF
}

resource "aws_iam_policy" "transcribe-lambda-policy" {
    name         = "transcribe-lambda-policy"
    path         = "/"
    policy = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "s3:ListBucket",
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": "arn:aws:s3:::*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "transcribe:StartTranscriptionJob",
                "transcribe:GetTranscriptionJob"
            ],                
            "Resource": "arn:aws:transcribe:us-west-2:166366443471:transcription-job/*",
            "Effect": "Allow"
        },
        {
            "Action": "ses:SendRawEmail",
            "Resource": "arn:aws:ses:us-west-2:166366443471:*/*",
            "Effect": "Allow"
        }
    ]
    }
    EOF
}

resource "aws_iam_role_policy_attachment" "attach-iam-policy-to-transcribe-lambda-role" {
 role        = aws_iam_role.transcribe-lambda-role.name
 policy_arn  = aws_iam_policy.transcribe-lambda-policy.arn
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.download-audio-function-715.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.transcriber-api-gateway.execution_arn}/*/*"
}

resource "aws_lambda_permission" "allow_bucket-transcribe" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.transcribe-function-715.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.audio-bucket-715.arn
}

resource "aws_lambda_permission" "allow_bucket-email" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.send-to-email-function-715.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.audio-bucket-715.arn
}