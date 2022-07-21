output "public_master_connection_string" {
  description = "Public SSH Connection"
  value       = "ssh -i ${var.local-key-pair} rocky@${module.instance_public_master.public_ip}"
}

output "public_node1_connection_string" {
  description = "Public SSH Connection"
  value       = "ssh -i ${var.local-key-pair} rocky@${module.instance_public_node_one.public_ip}"
}

output "public_node1_SMB_connection_string" {
  description = "SMB Connection"
  value       = "smbclient '\\\\master\\Public'"
}