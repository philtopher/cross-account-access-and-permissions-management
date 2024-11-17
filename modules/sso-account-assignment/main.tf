########################## AWS Account/OU Assignment ###################################

# Create Account Assignment to the group with Custom permission sets --> Production Account 
resource "aws_ssoadmin_account_assignment" "example" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.example.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.mypermissionset.arn  # Custom Permission set

  principal_id   = aws_identitystore_group.example.group_id  # Group
  principal_type = "GROUP"

  target_id   = "45465656566"   # Production Account
  target_type = "AWS_ACCOUNT"
  # target_type = "AWS_OU"      # Uncomment if targeting OU
}

# Create Account Assignment to the same group with Managed Permission sets --> Non-PRD
resource "aws_ssoadmin_account_assignment" "example2" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.example.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.ec2_admin_permissionset.arn  # Managed permission sets

  principal_id   = aws_identitystore_group.example.group_id  # Group
  principal_type = "GROUP"

  target_id   = "776677755"   # Non-Prd Account, replace with actual account or OU ID
  target_type = "AWS_ACCOUNT"
  # target_type = "AWS_OU"  # Uncomment if targeting OU
}

########################## AWS Managed Policy Attachment ##############################

# Attach managed policy to the permission set
resource "aws_ssoadmin_managed_policy_attachment" "ec2_admin_managed_policy_attachment" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.example.arns)[0]
  managed_policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  permission_set_arn = aws_ssoadmin_permission_set.ec2_admin_permissionset.arn
}
