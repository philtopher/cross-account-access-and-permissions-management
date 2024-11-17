# Fetch the AWS SSO instance
data "aws_ssoadmin_instances" "example" {}

# Create a custom permission set for EC2 Admin
resource "aws_ssoadmin_permission_set" "ec2_admin_permissionset" {
  name          = "EC2AdminPermissionSet"
  description   = "Permission set for EC2 Admin access"
  instance_arn  = data.aws_ssoadmin_instances.example.arns[0]
  session_duration = "PT8H"  # Session duration (8 hours)
}

# Create a custom permission set for the group
resource "aws_ssoadmin_permission_set" "mypermissionset" {
  name          = "MyCustomPermissionSet"
  description   = "Custom Permission set"
  instance_arn  = data.aws_ssoadmin_instances.example.arns[0]
  session_duration = "PT1H"  # Set session duration to 1 hour
}

# Attach the managed policy to the permission set
resource "aws_ssoadmin_managed_policy_attachment" "ec2_admin_managed_policy_attachment" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.example.arns)[0]
  managed_policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  permission_set_arn = aws_ssoadmin_permission_set.ec2_admin_permissionset.arn
}
