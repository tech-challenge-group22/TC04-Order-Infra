output "output_payment_queue_received" {
  value = "${aws_sqs_queue.PaymentQueueReceived.url}"
}

output "input_payment_queue_processed" {
  value = "${aws_sqs_queue.PaymentQueueProcessed.url}"
}

output "output_order_queue_received" {
  value = "${aws_sqs_queue.OrderQueueReceived.url}"
}

output "output_order_queue_finished" {
  value = "${aws_sqs_queue.OrderQueueFinished.url}"
}