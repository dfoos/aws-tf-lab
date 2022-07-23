variable "region" {
  type    = string
  default = "us-east-1"
}

variable "state_bucket" {
  type    = string
  default = "tf-state.derrickfoos.com"
}

variable "ami" {
  type    = string
  default = ""
}

variable "bucket_key" {
  type    = string
  default = "aws-lab"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_one" {
  type    = string
  default = "10.0.2.0/24"
}

variable "public_subnet_two" {
  type    = string
  default = "10.0.4.0/24"
}

variable "private_subnet_one" {
  type    = string
  default = "10.0.1.0/24"
}

variable "private_subnet_two" {
  type    = string
  default = "10.0.3.0/24"
}