resource "aws_iam_role" "iam_for_api_get" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "punk-api-get" {
  filename      = "package_punk-api-get.zip"
  function_name = "punk-api-get"
  role          = aws_iam_role.iam_for_api_get.arn
  handler       = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256("package_punk-api-get.zip")

  runtime = "python3.7"
}