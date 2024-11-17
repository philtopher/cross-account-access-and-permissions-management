# modules/users/main.tf
resource "aws_identitystore_user" "example" {
  identity_store_id = var.identity_store_id
  display_name      = "John Doe"
  user_name         = "johnny"

  name {
    given_name  = "John"
    family_name = "Doe"
  }

  emails {
    value = "john.doe@example.com"
  }
}

