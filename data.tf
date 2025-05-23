data "aws_vpc" "vpc_id" {
  filter {
    name   = "tag:Name"
    values = ["${var.instance_name}-vpc"]
  }
}

data "aws_subnets" "nacl_subnets" {
  filter {
    name   = "tag:Name"
    values = ["${var.instance_name}_public_sub-*"]
  }
}