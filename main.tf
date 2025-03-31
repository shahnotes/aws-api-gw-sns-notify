resource "aws_sns_topic" "email_notification" {
  name = var.sns_topic_name
}

resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.email_notification.arn
  protocol  = "email"
  endpoint  = var.sns_email
}
