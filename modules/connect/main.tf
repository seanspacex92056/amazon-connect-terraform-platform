resource "aws_connect_instance" "this" {
  identity_management_type = "CONNECT_MANAGED"
  inbound_calls_enabled    = true
  outbound_calls_enabled   = true
  instance_alias           = "${var.project_name}-${var.environment}"
}

resource "aws_connect_hours_of_operation" "business" {
  instance_id = aws_connect_instance.this.id
  name        = "Enterprise Support Hours"
  description = "Primary support coverage"
  time_zone   = "America/Los_Angeles"

  config {
    day = "MONDAY"
    end_time {
      hours   = 18
      minutes = 0
    }
    start_time {
      hours   = 6
      minutes = 0
    }
  }

  config {
    day = "TUESDAY"
    end_time {
      hours   = 18
      minutes = 0
    }
    start_time {
      hours   = 6
      minutes = 0
    }
  }

  config {
    day = "WEDNESDAY"
    end_time {
      hours   = 18
      minutes = 0
    }
    start_time {
      hours   = 6
      minutes = 0
    }
  }

  config {
    day = "THURSDAY"
    end_time {
      hours   = 18
      minutes = 0
    }
    start_time {
      hours   = 6
      minutes = 0
    }
  }

  config {
    day = "FRIDAY"
    end_time {
      hours   = 18
      minutes = 0
    }
    start_time {
      hours   = 6
      minutes = 0
    }
  }
}

resource "aws_connect_queue" "enterprise" {
  instance_id           = aws_connect_instance.this.id
  name                  = "Enterprise Support"
  description           = "General enterprise product support"
  hours_of_operation_id = aws_connect_hours_of_operation.business.hours_of_operation_id
}

resource "aws_connect_queue" "cloud" {
  instance_id           = aws_connect_instance.this.id
  name                  = "Cloud Platform Support"
  description           = "Cloud and platform engineering support"
  hours_of_operation_id = aws_connect_hours_of_operation.business.hours_of_operation_id
}

resource "aws_connect_queue" "priority" {
  instance_id           = aws_connect_instance.this.id
  name                  = "Priority Escalations"
  description           = "High priority enterprise escalations"
  hours_of_operation_id = aws_connect_hours_of_operation.business.hours_of_operation_id
}

resource "aws_connect_routing_profile" "support" {
  instance_id               = aws_connect_instance.this.id
  name                      = "Enterprise Support Routing"
  description               = "Routes agents across enterprise queues"
  default_outbound_queue_id = aws_connect_queue.enterprise.queue_id

  media_concurrencies {
    channel     = "VOICE"
    concurrency = 1
  }

  queue_configs {
    channel  = "VOICE"
    delay    = 0
    priority = 1
    queue_id = aws_connect_queue.priority.queue_id
  }

  queue_configs {
    channel  = "VOICE"
    delay    = 0
    priority = 5
    queue_id = aws_connect_queue.enterprise.queue_id
  }

  queue_configs {
    channel  = "VOICE"
    delay    = 0
    priority = 5
    queue_id = aws_connect_queue.cloud.queue_id
  }
}

resource "aws_connect_lambda_function_association" "customer_lookup" {
  function_arn = var.customer_lookup_lambda_arn
  instance_id  = aws_connect_instance.this.id
}

resource "aws_connect_instance_storage_config" "recordings" {
  instance_id   = aws_connect_instance.this.id
  resource_type = "CALL_RECORDINGS"

  storage_config {
    storage_type = "S3"

    s3_config {
      bucket_name   = replace(var.recordings_bucket_arn, "arn:aws:s3:::", "")
      bucket_prefix = "connect-recordings/${var.environment}"

      encryption_config {
        encryption_type = "KMS"
        key_id          = "alias/aws/s3"
      }
    }
  }
}

resource "aws_connect_contact_flow" "inbound" {
  instance_id = aws_connect_instance.this.id
  name        = "Enterprise Support Inbound"
  description = "Tier-aware inbound support routing"
  type        = "CONTACT_FLOW"

  content = templatefile("${path.root}/../../contact-flows/inbound-support.json.tftpl", {
    customer_lookup_lambda_arn = var.customer_lookup_lambda_arn
    enterprise_queue_id        = aws_connect_queue.enterprise.queue_id
    cloud_queue_id             = aws_connect_queue.cloud.queue_id
    priority_queue_id          = aws_connect_queue.priority.queue_id
  })
}
