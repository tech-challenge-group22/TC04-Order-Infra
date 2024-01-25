output "output_orderpayment_sqs_url" {
  value = "${aws_sqs_queue.order_received.url}"
}

output "output_orderconfirmed_sqs_url" {
  value = "${aws_sqs_queue.orderpayment_queue_received.url}"
}