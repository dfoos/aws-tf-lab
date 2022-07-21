terraform {
  backend "s3" {
    bucket = "tf-state.derrickfoos.com"
    key    = "aws-lab/main"
    region = "us-east-1"
  }
}

module "network" {
  source    = "./modules/network"
}

data "template_file" "user_data_master" {
  template = "${file("./files/userdata/master.sh")}"

  vars = {
    tag_name = "master"
  }
}

data "template_file" "user_data_node_one" {
  template = "${file("./files/userdata/node-one.sh")}"

  vars = {
    master_private_ip = module.instance_public_master.private_ip
    tag_name = "node1"
  }
}

module "instance_public_master" {
  source    = "./modules/instance_public"
  subnet = module.network.public_subnet_one
  key_name = var.instance-key-pair
  security_group = module.network.security_group_public
  ami = var.ami
  associate_public_ip = true
  tag_name = "master"
  user_data = "${data.template_file.user_data_master.rendered}"

}
module "instance_public_node_one" {
  source    = "./modules/instance_public"
  subnet = module.network.public_subnet_one
  key_name = var.instance-key-pair
  security_group = module.network.security_group_public
  ami = var.ami
  associate_public_ip = true
  tag_name = "node1"
  user_data = "${data.template_file.user_data_node_one.rendered}"
}
