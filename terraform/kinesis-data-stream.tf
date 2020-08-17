resource "aws_kinesis_stream" "data-stream" {
  name             = "data-stream"
  shard_count      = 4
  retention_period = 24

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]
}