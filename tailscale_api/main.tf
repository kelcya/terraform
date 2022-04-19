locals {
  tailscale_api = jsondecode(data.aws_secretsmanager_secret_version.ts_api_current.secret_string)["tailscale_api"]
  okta_api      = jsondecode(data.aws_secretsmanager_secret_version.okta_api_current.secret_string)["okta_api"]
  tailscale_users = {
    name    = "group:group1"
    members = values(data.okta_user.group1_user)[*].email
  }
}

resource "tailscale_acl" "main" {
  acl = jsonencode({
    acls : [
      // subnet 1 access
      {
        action = "accept",
        users  = [local.group1.name],
        ports  = ["subnet1:*"]
      },
    ],
    groups : {
      //Declare the tailscale group and their users
      "${local.group1.name}"         = local.group1.members,
    },
    hosts : {
      "subnet1" : "10.1.1.0/24",
      "subnet2" : "10.1.2.0/24"
    }
  })
}