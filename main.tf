provider "aws" {
 region = "us-east-1"
}

# terraform {
#   backend "s3" {
#     bucket         = "tfstate-tcfiap-group22"
#     key            = "terraform.tfstate"
#     region         = "us-east-1"
#   }
# }

resource "aws_vpc" "order_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "order_gateway_vpc" {
  vpc_id = aws_vpc.order_vpc.id
  tags = {
    Name = "order-gateway-vpc"
  }
}

resource "aws_route_table" "order_aws_route" {
  vpc_id = aws_vpc.order_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.order_gateway_vpc.id
  }
  tags = {
    Name = "order_aws_route"
  }
}
resource "aws_subnet" "order_public_subnet_a" {
  vpc_id = aws_vpc.order_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "order_public_subnet_b" {
  vpc_id = aws_vpc.order_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "order_subnet_association" {
  subnet_id     = aws_subnet.order_public_subnet_a.id
  route_table_id = aws_route_table.order_aws_route.id
}

resource "aws_route_table_association" "order_subnet_association_b" {
  subnet_id     = aws_subnet.order_public_subnet_b.id
  route_table_id = aws_route_table.order_aws_route.id
}

resource "aws_subnet" "order_private_subnet_a" {
  vpc_id = aws_vpc.order_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "order_private_subnet_b" {
  vpc_id = aws_vpc.order_vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_security_group" "order_inbound_security_group" {
  name        = "order_inbound_security_group"
  description = "Security Group"
  vpc_id = aws_vpc.order_vpc.id

  // Regra para HTTP
  ingress {
    from_port   = 0
    to_port     = 8080
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }


}

resource "aws_security_group" "order_database_security_group" {
  name = "order database secutiry group"
  description = "enable mysql/aurora"
  vpc_id = aws_vpc.order_vpc.id
   ingress {
    description = "mysql/aurora access"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.order_inbound_security_group.id]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name ="order database security group"
  }
}

resource "aws_db_instance" "order_db_rds" {
  allocated_storage = 10
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t2.micro"
  publicly_accessible = true
  identifier = "ms-order-rds"
  username = var.db_username
  password =  var.db_password
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.order_db_subnet.id
  vpc_security_group_ids = [aws_security_group.order_database_security_group.id]
  db_name = "Orders"
  
}

resource "aws_db_subnet_group" "order_db_subnet" {
    name = "order_dbsubnet"
    subnet_ids = [ aws_subnet.order_public_subnet_a.id , aws_subnet.order_public_subnet_b.id ]
  
}

resource "null_resource" "setup_db" {
  depends_on = [aws_db_instance.order_db_rds] #wait for the db to be ready
  triggers = {
    instance_id = aws_db_instance.order_db_rds.id
  }

  provisioner "local-exec" {
      command = "mysql -u${aws_db_instance.order_db_rds.username} -p${aws_db_instance.order_db_rds.password} -h${aws_db_instance.order_db_rds.address} -P${aws_db_instance.order_db_rds.port} < script-rds.sql"
   }
}

resource "aws_dynamodb_table" "aws_products_tbl" {
  name           = "tbl_products"
  billing_mode   = "PROVISIONED"  # Pode ser PAY_PER_REQUEST ou PROVISIONED
  read_capacity  = 5  # Capacidade de leitura por segundo (Apenas se o modo for PROVISIONED)
  write_capacity = 5  # Capacidade de gravação por segundo (Apenas se o modo for PROVISIONED)
  hash_key       = "id"
  
  attribute {
    name = "id"
    type = "N"  # Tipo de atributo: S (string), N (number), ou B (binary)
  }

  attribute {
    name = "item_type_id"
    type = "S"
  }

  ttl {
    attribute_name = "ttl"
    enabled        = true
  }

  global_secondary_index {
    name               = "index"
    hash_key           = "id"
    projection_type    = "ALL"  # Pode ser KEYS_ONLY, INCLUDE, ou ALL
    read_capacity      = 5
    write_capacity     = 5
  }
  global_secondary_index {
    name               = "index_type"
    hash_key           = "item_type_id"
    projection_type    = "ALL"  # Pode ser KEYS_ONLY, INCLUDE, ou ALL
    read_capacity      = 5
    write_capacity     = 5
  }
}