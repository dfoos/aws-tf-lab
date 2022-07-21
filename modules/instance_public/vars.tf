variable "ami" {
  type = string
}

variable "subnet" {
  type    = string
}

variable "key_name" {
  type    = string
}

variable "security_group" {
  type    = string
}

variable "associate_public_ip" {
  type    = bool
}

variable "tag_name" {
  type    = string
}

variable "user_data" {
  type    = string
}