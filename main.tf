# aws_sso_access_module/main.tf

provider "aws" {
  region = var.region
}

# Data sources for SSO instance and identity store
data "aws_ssoadmin_instances" "example" {}

# The identity_store_id and instance_arn from the SSO instance
locals {
  identity_store_id = tolist(data.aws_ssoadmin_instances.example.identity_store_ids)[0]
  instance_arn      = tolist(data.aws_ssoadmin_instances.example.arns)[0]
}

# Call submodule for users
module "users" {
  source            = "./modules/users"
  identity_store_id = local.identity_store_id
}

# Call submodule for groups
module "groups" {
  source            = "./modules/groups"
  identity_store_id = local.identity_store_id
  member_id         = module.users.user_ids[0] # Example usage of user ID from users module
}

# Call submodule for permissions
module "permissions" {
  source       = "./modules/permissions"
  instance_arn = local.instance_arn
}
