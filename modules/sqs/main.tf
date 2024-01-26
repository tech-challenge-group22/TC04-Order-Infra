resource "aws_sqs_queue" "order_received" {
    name                        = "order_received.fifo"
    delay_seconds               = 0
    visibility_timeout_seconds  = 30
    max_message_size            = 2048
    message_retention_seconds   = 86400
    receive_wait_time_seconds   = 2
    fifo_queue                  = true
    content_based_deduplication = true
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

resource "aws_sqs_queue" "order_received_deadletter_queue" {
  name                        = "order_received-dlq.fifo"
  fifo_queue                  = true
  content_based_deduplication = aws_sqs_queue.order_received.content_based_deduplication
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.order_received.arn,
    maxReceiveCount     = 5  # Adjust as needed
  })
}

resource "aws_sqs_queue" "orderpayment_queue_received" {
    name                        = "orderpayment_queue_received.fifo"
    delay_seconds               = 0
    visibility_timeout_seconds  = 30
    max_message_size            = 2048
    message_retention_seconds   = 86400
    receive_wait_time_seconds   = 2
    fifo_queue                  = true
    content_based_deduplication = true
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

resource "aws_sqs_queue" "orderpayment_queue_received_dlq" {
  name                        = "orderpayment-queue-received-dlq.fifo"
  fifo_queue                  = true
  content_based_deduplication = aws_sqs_queue.orderpayment_queue_received.content_based_deduplication
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.orderpayment_queue_received.arn,
    maxReceiveCount     = 5  # Adjust as needed
  })
}