resource "aws_kms_key" "kms_key" {
  deletion_window_in_days = 7
  description             = "Athena KMS Key"
}

resource "aws_athena_workgroup" "athena_wg" {
  name = "athena_wg"
  depends_on = [aws_s3_bucket.punkapi-brew-raw, aws_s3_bucket.punkapi-brew-cleaned, aws_kinesis_stream.data-stream, aws_lambda_function.punk-api-cleaner, aws_lambda_function.punk-api-get]

  configuration {
    result_configuration {
      encryption_configuration {
        encryption_option = "SSE_KMS"
        kms_key_arn       = aws_kms_key.kms_key.arn
      }
    }
  }
}

resource "aws_athena_database" "cleaned_data" {
  name   = "cleanedbrewdata"
  bucket = aws_s3_bucket.punkapi-brew-cleaned.id
}

resource "aws_athena_named_query" "sample" {
  name      = "sample_query"
  workgroup = aws_athena_workgroup.athena_wg.id
  database  = aws_athena_database.cleaned_data.name
  query     = "SELECT * FROM ${aws_athena_database.cleaned_data.name} limit 10;"
}