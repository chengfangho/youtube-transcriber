resource "aws_api_gateway_rest_api" "transcriber-api-gateway" {
  name = "transcriber-api-gateway"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "transcriber-api-gateway-resource" {
  rest_api_id = aws_api_gateway_rest_api.transcriber-api-gateway.id
  parent_id   = aws_api_gateway_rest_api.transcriber-api-gateway.root_resource_id
  path_part   = "extract"
}

resource "aws_api_gateway_method" "transcriber-api-method-post"{
    authorization = "NONE"
    http_method = "POST"
    resource_id = aws_api_gateway_resource.transcriber-api-gateway-resource.id
    rest_api_id = aws_api_gateway_rest_api.transcriber-api-gateway.id
}

resource "aws_api_gateway_method_response" "transcriber-api-method-response-post" {
  http_method = "POST"
  resource_id = aws_api_gateway_resource.transcriber-api-gateway-resource.id
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "false"
  }
  rest_api_id = aws_api_gateway_rest_api.transcriber-api-gateway.id
  status_code = "200"
}

resource "aws_api_gateway_integration" "transcriber-api-integration-post" {
  connection_type         = "INTERNET"
  content_handling        = "CONVERT_TO_TEXT"
  http_method             = aws_api_gateway_method.transcriber-api-method-post.http_method
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  resource_id             = aws_api_gateway_resource.transcriber-api-gateway-resource.id
  rest_api_id             = aws_api_gateway_rest_api.transcriber-api-gateway.id
  timeout_milliseconds    = "29000"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.download-audio-function-715.invoke_arn
}

resource "aws_api_gateway_method" "transcriber-api-method-option"{
    authorization = "NONE"
    http_method = "OPTIONS"
    resource_id = aws_api_gateway_resource.transcriber-api-gateway-resource.id
    rest_api_id = aws_api_gateway_rest_api.transcriber-api-gateway.id
}

resource "aws_api_gateway_method_response" "transcriber-api-method-response-option" {
  http_method = "OPTIONS"
  resource_id = aws_api_gateway_resource.transcriber-api-gateway-resource.id
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "false"
    "method.response.header.Access-Control-Allow-Methods" = "false"
    "method.response.header.Access-Control-Allow-Origin"  = "false"
  }
  rest_api_id = aws_api_gateway_rest_api.transcriber-api-gateway.id
  status_code = "200"
}

resource "aws_api_gateway_integration" "transcriber-api-integration-option" {
  connection_type      = "INTERNET"
  http_method          = "OPTIONS"
  passthrough_behavior = "WHEN_NO_MATCH"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  resource_id          = aws_api_gateway_resource.transcriber-api-gateway-resource.id
  rest_api_id          = aws_api_gateway_rest_api.transcriber-api-gateway.id
  timeout_milliseconds = "29000"
  type                 = "MOCK"
}