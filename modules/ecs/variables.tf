variable "prefix" {
  description = "The prefix"
}

variable "vpc_id" {
  description = "The VPC id"
}

variable "availability_zones" {
  type        = list(string)
  description = "The azs to use"
}

variable "security_groups_ids" {
  description = "The SGs to use"
}

variable "subnets_ids" {
  type    = list(string)
  description = "The private subnets to use"
}

variable "public_subnet_ids" {
  description = "The private subnets to use"
}

variable "database_endpoint" {
  description = "The database endpoint"
}

variable "database_username" {
  description = "The database username"
}

variable "database_password" {
  description = "The database password"
}

variable "database_name" {
  description = "The database that the app will use"
}

variable "repository_name" {
  description = "The name of the repisitory"
}

variable "execution_arn_role" {
  description = "arn of execution role"
}

variable "dbhost" {
  description = "dbhost"
}

variable "rds_id" {
  description = "dbhost"
}

variable "session_token_aws" {
  description = "AWS session token"
}

variable "access_key_aws" {
  description = "AWS session token"
}

variable "secret_aws" {
  description = "AWS session token"
}

variable "output_orderpayment_sqs_url" {
}

variable "output_orderconfirmed_sqs_url" {
}

variable input_paymentprocessed_sqs_url {
}

variable input_queue_finished_sqs_url {
}

variable sqs_polling_interval {
}

variable sqs_message_group {
}
