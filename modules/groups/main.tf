# modules/groups/main.tf
resource "aws_identitystore_group" "example" {
  identity_store_id = var.identity_store_id
  display_name      = "L1-ops-group"
  description       = "This is my AWS ops Group"
}

resource "aws_identitystore_group_membership" "example" {
  identity_store_id = var.identity_store_id
  group_id          = aws_identitystore_group.example.group_id
  member_id         = var.member_id
}
