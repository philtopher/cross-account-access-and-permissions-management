# Output the ARN of the permission sets
output "permission_set_arns" {
  value = [
    aws_ssoadmin_permission_set.ec2_admin_permissionset.arn,
    aws_ssoadmin_permission_set.mypermissionset.arn
  ]
}
