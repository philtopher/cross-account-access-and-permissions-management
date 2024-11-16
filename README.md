AWS SSO Access Management Terraform Module
This repository contains Terraform modules for managing AWS Single Sign-On (SSO) user access. The modules help you automate user and group management, assign permission sets, and assign these permission sets to specific AWS accounts or organizational units (OUs). The goal is to create a modular, scalable, and reusable infrastructure setup using Terraform to manage your AWS SSO environment.

Prerequisites
Before using this Terraform module, ensure the following prerequisites are met:

An AWS account with AWS SSO enabled.
Terraform installed (v0.12+ recommended).
AWS CLI configured with appropriate access.
Module Overview
The module is split into the following components:

Root Module: The root module provides high-level orchestration, importing necessary sub-modules, and wiring resources together.
Sub-Modules:
users: Manages SSO user creation and attributes.
groups: Manages SSO group creation and membership.
permissions: Manages permission sets and policy attachments.
account_assignment: Manages account and OU assignments for groups.
Architecture
This setup is divided into multiple files and sub-modules to maintain clean code and modularity.
```markdown
File Structure

aws-sso-access-management/ │ ├── main.tf # Root module, imports sub-modules ├── variables.tf # Root module variables ├── outputs.tf # Root module outputs ├── modules/ │ ├── users/ │ │ ├── main.tf # SSO user creation resources │ │ └── outputs.tf # Outputs for users module │ ├── groups/ │ │ ├── main.tf # SSO group creation and membership │ │ └── outputs.tf # Outputs for groups module │ ├── permissions/ │ │ ├── main.tf # Permission sets and policy attachment │ │ └── outputs.tf # Outputs for permissions module │ └── account_assignment/ │ ├── main.tf # Account and OU assignment resources │ └── outputs.tf # Outputs for account assignment module └── README.md # Documentation for the setup

Root Module (main.tf)
The main.tf file imports the sub-modules for managing users, groups, permissions, and account assignments. It initializes the AWS provider and handles orchestration of resources across all modules.

Sub-Module Breakdown

modules/users/main.tf

This module handles the creation of SSO users within your identity store. It defines a resource to create users and set their attributes like email, display name, etc.

modules/groups/main.tf

This module creates SSO groups and assigns users to those groups. Group membership is defined to map users to the right groups for access control.

modules/permissions/main.tf

This module creates permission sets for AWS resources, attaches inline or managed policies, and assigns them to users or groups. It also handles policy attachments like Amazon EC2 Full Access for group permissions.

modules/account_assignment/main.tf

This module manages account assignments for groups or users to specific AWS accounts or organizational units (OUs). It defines the permissions for each group and assigns them to the target AWS accounts.

Step-by-Step Guide to Deploy AWS SSO Access Management
Step 1: Clone the Repository
First, clone this repository to your local machine:

git clone <repository-url>
cd aws-sso-access-management
Step 2: Configure AWS CLI

Ensure that your AWS CLI is configured with proper access permissions to manage AWS SSO. You can do this by running:

aws configure

Provide your AWS access key, secret key, and the default region when prompted.

Step 3: Customize Terraform Variables
You may need to modify the variables.tf file to specify values specific to your environment, such as AWS region, identity store IDs, and user details.

Step 4: Initialize Terraform
Run terraform init to initialize the Terraform working directory and download required providers:

terraform init

Step 5: Apply Terraform Configuration
To apply the configuration and create the AWS SSO resources, run:

terraform apply

Terraform will prompt you to confirm before applying the changes. Type yes to proceed.

Step 6: Verify the Deployment
Once the deployment is complete, you can verify the following resources in your AWS SSO console:

Users: Users should be created under the Identity Store section.
Groups: Groups should appear in the Groups section of the AWS SSO console.
Permission Sets: Check the permission sets under the Permission Sets section.
Account Assignments: Verify that the groups are assigned to the appropriate AWS accounts or organizational units.
Detailed Breakdown of Key Resources
aws_identitystore_user
This resource creates a new SSO user within your identity store. It is associated with the user’s email, display name, and user name.

Example:


resource "aws_identitystore_user" "example" {
  identity_store_id = "example_identity_store_id"
  display_name      = "John Doe"
  user_name         = "johndoe"
  emails {
    value = "johndoe@example.com"
  }
}
aws_identitystore_group
This resource defines an SSO group, such as "Admin" or "Ops". Users are assigned to these groups for access control.

Example:


resource "aws_identitystore_group" "example" {
  identity_store_id = "example_identity_store_id"
  display_name      = "Admin Group"
}
aws_ssoadmin_permission_set
This resource defines a permission set that determines the permissions a user or group has. The permission set can be attached to a managed policy, such as AmazonEC2FullAccess.

Example:

resource "aws_ssoadmin_permission_set" "example" {
  name         = "EC2 Full Access"
  instance_arn = "example_instance_arn"
}
aws_ssoadmin_managed_policy_attachment
This resource attaches a managed policy, like AmazonEC2FullAccess, to a permission set.

Example:


resource "aws_ssoadmin_managed_policy_attachment" "ec2_admin_managed_policy_attachment" {
  instance_arn       = "example_instance_arn"
  managed_policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  permission_set_arn = "example_permission_set_arn"
}
aws_ssoadmin_account_assignment
This resource assigns a permission set to a specific AWS account or organizational unit (OU). You can assign permissions to users or groups for a given target.

Example:


resource "aws_ssoadmin_account_assignment" "example" {
  instance_arn       = "example_instance_arn"
  permission_set_arn = "example_permission_set_arn"
  principal_id       = "example_group_id"
  principal_type     = "GROUP"
  target_id          = "target_account_id"
  target_type        = "AWS_ACCOUNT"
}
Output Variables
The module outputs certain values that you can use in other Terraform configurations or external tools. Some of the key outputs include:

permission_set_arns: ARN of the permission sets.
user_ids: List of user IDs created in the Identity Store.
group_ids: List of group IDs created for user membership.

Key RBAC Features Covered in the Tutorial:

Groups:

The project defines groups using the aws_identitystore_group resource. For example, the group L1-ops-group is created to represent a specific set of users.
Users are assigned to these groups via aws_identitystore_group_membership.

Users:

It creates users using the aws_identitystore_user resource. In this case, the user e.g. John Doe is created and assigned to the L1-ops-group.

Roles/Permission Sets:

Permission sets are created using aws_ssoadmin_permission_set. These permission sets define the level of access users have, such as a S3 Read-only permission set or an EC2 Admin permission set.
The permissions attached to these roles control which actions can be performed on specific resources, for example, s3:ListAllMyBuckets for read-only access to S3 buckets.

Assignments to Groups:

The project uses the aws_ssoadmin_account_assignment resource to assign the permission sets to groups (e.g., L1-ops-group) across different AWS accounts or Organizational Units (OUs).
The assignment includes the principal type (e.g., group) and the target type (either an AWS account or an OU), effectively controlling access to AWS resources based on the group membership.

Role-Based Access Control (RBAC) in Action:
Groups: Users are assigned to specific groups, and each group can have different access permissions based on the roles they are assigned.

Roles/Permission Sets: The permission sets specify what actions users in a given role can perform on AWS resources. For example, the my-s3-permissionset allows users to list and get details about S3 buckets.

Account/Ou Assignment: Groups are assigned permission sets to specific accounts or organizational units (OUs), thus granting access to those accounts and resources as specified in the permission sets.

RBAC Summary:
The project sets up a role-based access model for AWS resources, where:

Groups represent roles.
Users are members of these roles (groups).
Permission sets define the access that each role (group) has to resources.
Account assignments ensure that users/groups have the appropriate permissions in specific AWS accounts or OUs.

Does it include full RBAC?
While this project provides a basic RBAC setup using AWS SSO, it could be extended further depending on more complex organizational structures or specific requirements (like more granular permissions or multiple groups with different roles). However, the foundational concepts of RBAC—defining users, groups, roles (permission sets), and resource access—are covered in this tutorial.

Conclusion
This Terraform module provides an automated and scalable way to manage AWS SSO users, groups, permissions, and account assignments. By structuring the code into modules, you can reuse the configuration across multiple environments and AWS accounts, while maintaining flexibility and ease of management.

Feel free to extend the module to include additional features like multi-account support, dynamic permission set creation, and more!
