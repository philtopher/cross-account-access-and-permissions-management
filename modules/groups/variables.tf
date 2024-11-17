# modules/groups/variables.tf
variable "identity_store_id" {
  description = "The ID of the AWS SSO Identity Store"
  type        = string
}

variable "member_id" {
  description = "The ID of the user to add to the group"
  type        = string
}

