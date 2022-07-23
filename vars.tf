variable "region" {
  description = "AWS region"
  default     = "us-east-1"
  type        = string
}
variable "instance-key-pair" {
  description = "existing keypair to use"
  default     = "lab-keypair"
  type        = string
}

variable "local-key-pair" {
  description = "location of private key file"
  default     = "~/lab-keypair.pem"
  type        = string
}

variable "ami" {
  type    = string
  default = "ami-043ceee68871e0bb5"
}