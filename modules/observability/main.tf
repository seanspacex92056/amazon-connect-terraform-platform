resource "aws_s3_bucket" "recordings" {
  bucket_prefix = "${var.project_name}-${var.environment}-recordings-"
  tags          = var.tags
}

resource "aws_s3_bucket_versioning" "recordings" {
  bucket = aws_s3_bucket.recordings.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "recordings" {
  bucket = aws_s3_bucket.recordings.id
  rule {
    apply_server_side_encryption_by_default { sse_algorithm = "AES256" }
  }
}

resource "aws_cloudwatch_metric_alarm" "missed_calls" {
  alarm_name          = "${var.project_name}-${var.environment}-connect-missed-calls"
  alarm_description   = "Amazon Connect missed calls exceeded threshold"
  namespace           = "AWS/Connect"
  metric_name         = "MissedCalls"
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 5
  comparison_operator = "GreaterThanThreshold"
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = var.connect_instance_id
  }

  tags = var.tags
}

output "recordings_bucket_arn" { value = aws_s3_bucket.recordings.arn }
