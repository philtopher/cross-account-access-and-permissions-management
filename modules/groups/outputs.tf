# modules/groups/outputs.tf
output "group_ids" {
  description = "List of group IDs created"
  value       = [aws_identitystore_group.example.group_id]
}
