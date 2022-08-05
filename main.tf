terraform {
  backend "s3" {
    bucket = "tf-state.derrickfoos.com"
    key    = "aws-lab/main"
    region = "us-east-1"
  }
}

module "network" {
  source = "./modules/network"
}

data "template_file" "user_data_management" {
  template = file("./files/userdata/management.sh")

  vars = {
    tag_name = "management"
    samba_password = random_string.smb_password.result
  }
}

data "template_file" "user_data_node_one" {
  template = file("./files/userdata/node-one.sh")

  vars = {
    management_private_ip = module.instance_public_management.private_ip
    tag_name          = "node1"
    samba_password = random_string.smb_password.result
  }
}

module "instance_public_management" {
  source              = "./modules/instance_public"
  subnet              = module.network.public_subnet_one
  key_name            = var.instance-key-pair
  security_group      = module.network.security_group_public
  ami                 = var.ami
  associate_public_ip = true
  tag_name            = "management"
  user_data           = data.template_file.user_data_management.rendered

}
module "instance_public_node_one" {
  source              = "./modules/instance_public"
  subnet              = module.network.public_subnet_one
  key_name            = var.instance-key-pair
  security_group      = module.network.security_group_public
  ami                 = var.ami
  associate_public_ip = true
  tag_name            = "node1"
  user_data           = data.template_file.user_data_node_one.rendered
}

resource "random_string" "smb_password" {
  length           = 16
  special          = false
}