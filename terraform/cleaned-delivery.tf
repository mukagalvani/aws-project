resource "aws_kinesis_firehose_delivery_stream" "cleaned-delivery" {
  name        = "cleaned-delivery"
  destination = "extended_s3"
  depends_on = [aws_s3_bucket.punkapi-brew-raw, aws_s3_bucket.punkapi-brew-cleaned, aws_kinesis_stream.data-stream, aws_lambda_function.punk-api-cleaner, aws_lambda_function.punk-api-get]

  extended_s3_configuration {
    role_arn   = aws_iam_role.cleaned_delivery_role.arn
    bucket_arn = aws_s3_bucket.punkapi-brew-cleaned.arn

    processing_configuration {
      enabled = "true"

      processors {
        type = "Lambda"

        parameters {
          parameter_name  = "LambdaArn"
          parameter_value = "${aws_lambda_function.punk-api-cleaner.arn}:$LATEST"
        }
      }
    }
  }
}

resource "aws_iam_role" "cleaned_delivery_role" {
  name = "cleaned-delivery-iam-role"

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
