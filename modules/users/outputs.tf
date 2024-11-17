# modules/users/outputs.tf
output "user_ids" {
  description = "List of user IDs created"
  value       = [aws_identitystore_user.example.user_id]
}
