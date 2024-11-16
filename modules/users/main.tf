# modules/users/main.tf
resource "aws_identitystore_user" "example" {
  identity_store_id = var.identity_store_id
  display_name      = "Tochi Akagbulem"
  user_name         = "tochai"

  name {
    given_name  = "Tochi"
    family_name = "Unamka"
  }

  emails {
    value = "tufort-facebk@yahoo.co.uk"
  }
}

