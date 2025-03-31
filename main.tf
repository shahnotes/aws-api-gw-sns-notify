resource "aws_sns_topic" "email_notification" {
  name = var.sns_topic_name
}

resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.email_notification.arn
  protocol  = "email"
  endpoint  = var.sns_email
}

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