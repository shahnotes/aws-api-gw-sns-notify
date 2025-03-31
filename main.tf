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

data "aws_iam_policy_document" "agw_sns_topic_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "allow_agw_publish_sns" {
  statement {
    effect    = "Allow"
    actions   = ["sns:Publish"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "api_gateway_sns_role" {
  name               = "api_gateway_sns_role"
  assume_role_policy = data.aws_iam_policy_document.agw_sns_topic_assume_role.json
}

resource "aws_iam_policy" "allow_lambda_sns" {
  name   = "allow_lambda_sns"
  policy = data.aws_iam_policy_document.allow_agw_publish_sns.json
}

resource "aws_iam_role_policy_attachment" "api_gateway_sns_attachment_sns" {
  policy_arn = aws_iam_policy.allow_lambda_sns.arn
  role       = aws_iam_role.api_gateway_sns_role.name
}
