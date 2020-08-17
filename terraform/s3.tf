resource "aws_s3_bucket" "punkapi-brew-cleaned" {
  bucket = "punkapi-brew-cleaned"
  acl    = "private"
}

resource "aws_s3_bucket" "punkapi-brew-raw" {
  bucket = "punkapi-brew-raw"
  acl    = "private"
}

