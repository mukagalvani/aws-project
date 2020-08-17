resource "aws_iam_role" "raw-delivery-role" {
  name = "raw-delivery-iam-role"
  depends_on = [aws_s3_bucket.punkapi-brew-raw, aws_s3_bucket.punkapi-brew-cleaned, aws_kinesis_stream.data-stream, aws_lambda_function.punk-api-cleaner, aws_lambda_function.punk-api-get]

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_kinesis_firehose_delivery_stream" "raw-delivery" {
  name        = "raw-delivery"
  destination = "s3"

  s3_configuration {
    role_arn   = aws_iam_role.raw-delivery-role.arn
    bucket_arn = aws_s3_bucket.punkapi-brew-raw.arn
  }

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.data-stream.arn
    role_arn = aws_iam_role.raw-delivery-role.arn
  }
}