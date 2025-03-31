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