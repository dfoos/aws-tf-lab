output "vpc_name" {
  value = aws_vpc.lab-vpc.id
}

output "public_subnet_one" {
  value = aws_subnet.sn-public-one.id
}

output "security_group_public" {
  value = aws_security_group.allow_ssh_pub.id
}