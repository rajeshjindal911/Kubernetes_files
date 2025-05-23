variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "instance_name" {
  description = "AWS region"
  type        = string
  default     = "natwest_test"
}
variable "nodename" {
  type = string
  default = "natwest"
}

variable "env" {
  type = string
  default = "dev"
}

variable "nodeid" {
  type = number
  default = "911"
}

variable "key_pair" {
  type = string
  default = "vpc-endpoint"
}


