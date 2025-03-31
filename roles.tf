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
