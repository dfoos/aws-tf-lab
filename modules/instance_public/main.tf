// Configure the EC2 instance in a public subnet
resource "aws_instance" "ec2_public" {
  ami                         = var.ami
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  subnet_id                   = var.subnet
  vpc_security_group_ids      = [var.security_group]
  user_data                   = var.user_data
  tags = {
    "name" = "lab-bastion-public"
    "hostname" = var.tag_name
  }
}