resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "lab-key"
  public_key = tls_private_key.private_key.public_key_openssh

  provisioner "local-exec" {
    command = "rm -f ./lab-key.pem"
  }

  provisioner "local-exec" {
    command = "echo '${tls_private_key.private_key.private_key_pem}' > ./lab-key.pem"
  }

  provisioner "local-exec" {
    command = "chmod 400 ./lab-key.pem"
  }
}