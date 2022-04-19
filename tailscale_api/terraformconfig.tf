terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 3.20"
    }
    tailscale = {
      source  = "davidsbond/tailscale"
      version = "0.9.0"
    }
  }
  backend "s3" {
    // Add your s3 bucket for terraform state
  }
  required_version = ">= 1.1.7"
}

# Configure the Okta Provider with okta service account token
provider "okta" {
  org_name  = "cedar"
  base_url  = "okta.com"
  api_token = local.okta_api
}

# Configure the Tailscale Provider with tailscale service account token
provider "tailscale" {
  api_key = local.tailscale_api
  tailnet = "cedar.com"
}

provider "aws" {
  region = "us-east-1"
} 