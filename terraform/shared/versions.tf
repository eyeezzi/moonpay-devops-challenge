terraform {
  required_version = ">= 1.5"

  backend "gcs" {
    bucket = "moonpay-terraform-state"
    prefix = "shared"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}
