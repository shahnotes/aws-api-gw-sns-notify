resource "aws_api_gateway_rest_api" "sns_api" {
  name        = var.sns_rest_api_name
  description = "API Gateway to trigger SNS Email Notification"
}

resource "aws_api_gateway_resource" "sns_resource" {
  rest_api_id = aws_api_gateway_rest_api.sns_api.id
  parent_id   = aws_api_gateway_rest_api.sns_api.root_resource_id
  path_part   = "sns"
}

resource "aws_api_gateway_method" "sns_post" {
  rest_api_id   = aws_api_gateway_rest_api.sns_api.id
  resource_id   = aws_api_gateway_resource.sns_resource.id
  http_method   = "POST"
  authorization = "NONE"
  request_parameters = {
    "method.request.querystring.Message"  = true,
    "method.request.querystring.TopicArn" = true,
  }
}

resource "aws_api_gateway_integration" "sns_integration" {
  rest_api_id             = aws_api_gateway_rest_api.sns_api.id
  resource_id             = aws_api_gateway_method.sns_post.resource_id
  http_method             = aws_api_gateway_method.sns_post.http_method
  type                    = "AWS"
  integration_http_method = "POST"
  uri                     = "arn:aws:apigateway:${var.region}:sns:path//"

  request_parameters = {
    "integration.request.querystring.Message"  = "method.request.querystring.Message"
    "integration.request.querystring.TopicArn" = "method.request.querystring.TopicArn"
  }

  credentials = aws_iam_role.api_gateway_sns_role.arn
}

resource "aws_api_gateway_deployment" "sns_deployment" {
  rest_api_id = aws_api_gateway_rest_api.sns_api.id
  depends_on = [
    aws_api_gateway_integration.sns_integration
  ]
}

resource "aws_api_gateway_stage" "sandbox_stage" {
  deployment_id = aws_api_gateway_deployment.sns_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.sns_api.id
  stage_name    = "v1"
}
