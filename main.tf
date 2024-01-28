/*====
Variables used across all modules
======*/
locals {
  production_availability_zones = ["us-east-1a", "us-east-1b"]
}

provider "aws" {
  region  = "${var.region}"
}

terraform {
  backend "s3" {
    bucket         = "tfstate-tcfiap-order"
    key            = "terraform.tfstate"
    region         = "us-east-1"
  }
}

module "networking" {
  source               = "./modules/networking"
  prefix          = "order"
  vpc_cidr             = "10.0.0.0/16"
  public_subnets_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets_cidr = ["10.0.10.0/24", "10.0.20.0/24"]
  region               = "${var.region}"
  availability_zones   = "${local.production_availability_zones}"
  key_name             = "production_key"
}

module "rds" {
  source            = "./modules/rds"
  prefix       = "order"
  allocated_storage = "10"
  database_name     = "${var.database_name}"
  database_username = "${var.database_username}"
  database_password = "${var.database_password}"
  subnet_ids        = module.networking.public_subnets_id
  vpc_id            = "${module.networking.vpc_id}"
  instance_class    = "db.t2.micro"
  depends_on = [
    module.networking
  ]
}

module dynamo {
  source = "./modules/dynamo"
}

module sqs {
  source = "./modules/sqs"
}

module "ecs" {
  source              = "./modules/ecs"
  prefix              = "order"
  vpc_id              = "${module.networking.vpc_id}"
  availability_zones  = "${local.production_availability_zones}"
  repository_name     = "order/production"
  subnets_ids         = module.networking.private_subnets_id
  public_subnet_ids   = module.networking.public_subnets_id
  security_groups_ids = [
    module.networking.security_groups_ids,
    module.rds.db_access_sg_id
  ]
  database_endpoint   = "${module.rds.rds_address}"
  database_name       = "${var.database_name}"
  database_username   = "${var.database_username}"
  database_password   = "${var.database_password}"
  session_token_aws   = "${var.session_token_aws}"
  access_key_aws      = "${var.access_key_aws}"
  secret_aws          = "${var.secret_aws}"
  dbhost              = "${module.rds.rds_address}"
  execution_arn_role  = "${var.lab_role_arn}"
  rds_id              = "${module.rds.rds_id}"
  output_payment_queue_received    = "${module.sqs.output_payment_queue_received}"
  input_payment_queue_processed  = "${module.sqs.input_payment_queue_processed}"
  output_order_queue_received  = "${module.sqs.output_order_queue_received}"
  output_order_queue_finished  = "${module.sqs.output_order_queue_finished}"
  sqs_message_group    = "${var.sqs_message_group}"
  sqs_polling_interval = "${var.sqs_polling_interval}"
  depends_on = [
    module.rds,
    module.dynamo,
    module.networking
  ]
}
