data "aws_secretsmanager_secret" "tailscale_api" {
  name = <aws_secrets_name>
}

data "aws_secretsmanager_secret_version" "ts_api_current" {
  secret_id = data.aws_secretsmanager_secret.tailscale_api.id
}

data "aws_secretsmanager_secret" "okta_api" {
  name = <aws_secrets_name>
}

data "aws_secretsmanager_secret_version" "okta_api_current" {
  secret_id = data.aws_secretsmanager_secret.okta_api.id
}

# Get user ids of okta groups
data "okta_group" "group1" {
  // Replace with your okta group name
  name          = <okta_group_name>
  include_users = true
}

# Get okta user information
data "okta_user" "group1_user" {
  for_each = data.okta_group.group1.users
  user_id  = each.key
}