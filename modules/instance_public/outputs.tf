output "public_ip" {
  value = aws_instance.ec2_public.public_ip
}

output "private_ip" {
  value = aws_instance.ec2_public.private_ip
}

output "tag_name" {
  value = "${lookup(aws_instance.ec2_public.tags, "hostname")}"
}