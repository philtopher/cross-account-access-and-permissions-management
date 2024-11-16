# aws_sso_access_module/outputs.tf
output "user_ids" {
  description = "User IDs from users submodule"
  value       = module.users.user_ids
}

output "group_ids" {
  description = "Group IDs from groups submodule"
  value       = module.groups.group_ids
}

output "permission_set_arns" {
  description = "Permission set ARNs from permissions submodule"
  value       = module.permissions.permission_set_arns
}
