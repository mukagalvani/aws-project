resource "aws_cloudwatch_event_rule" "trigger-api-get" {
  name                = "every-one-minute"
  description         = "Triggers punk-api-get lambda function every 1 minute"
  schedule_expression = "rate(1 minute)"
  depends_on = [aws_kinesis_stream.data-stream, aws_s3_bucket.punkapi-brew-cleaned, aws_s3_bucket.punkapi-brew-raw, aws_lambda_function.punk-api-get, aws_lambda_function.punk-api-cleaner]
}

resource "aws_cloudwatch_event_target" "trigger-api-get-every-one-min" {
  rule      = "aws_cloudwatch_event_rule.trigger-api-get.name"
  target_id = "lambda"
  arn       = aws_lambda_function.punk-api-get.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_trigger_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.punk-api-get.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.trigger-api-get.arn
}