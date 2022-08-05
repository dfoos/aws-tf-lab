output "public_management_connection_string" {
  description = "Public SSH Connection"
  value       = "ssh -i ${var.local-key-pair} rocky@${module.instance_public_management.public_ip}"
}

output "public_node1_connection_string" {
  description = "Public SSH Connection"
  value       = "ssh -i ${var.local-key-pair} rocky@${module.instance_public_node_one.public_ip}"
}

output "samba_password" {
  description = "Randomly generated pasword used for SAMBA shares"
  value       = random_string.smb_password.result
}