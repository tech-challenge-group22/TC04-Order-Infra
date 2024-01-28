resource "aws_sqs_queue" "PaymentQueueReceived" {
    name                        = "PaymentQueueReceived.fifo"
    delay_seconds               = 0
    visibility_timeout_seconds  = 30
    max_message_size            = 2048
    message_retention_seconds   = 86400
    receive_wait_time_seconds   = 2
    fifo_queue                  = true
    content_based_deduplication = false
    policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
      }
    ]
  })
}

resource "aws_sqs_queue" "PaymentQueueProcessed" {
    name                        = "PaymentQueueProcessed.fifo"
    delay_seconds               = 0
    visibility_timeout_seconds  = 30
    max_message_size            = 2048
    message_retention_seconds   = 86400
    receive_wait_time_seconds   = 2
    fifo_queue                  = true
    content_based_deduplication = false
    policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
      }
    ]
  })
}

resource "aws_sqs_queue" "OrderQueueReceived" {
    name                        = "OrderQueueReceived.fifo"
    delay_seconds               = 0
    visibility_timeout_seconds  = 30
    max_message_size            = 2048
    message_retention_seconds   = 86400
    receive_wait_time_seconds   = 2
    fifo_queue                  = true
    content_based_deduplication = false
    policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
      }
    ]
  })
}

resource "aws_sqs_queue" "OrderQueueFinished" {
    name                        = "OrderQueueFinished.fifo"
    delay_seconds               = 0
    visibility_timeout_seconds  = 30
    max_message_size            = 2048
    message_retention_seconds   = 86400
    receive_wait_time_seconds   = 2
    fifo_queue                  = true
    content_based_deduplication = false
    policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
      }
    ]
  })
}