provider "google" {
  project = var.project_id
  region  = var.region
}

locals {
  github_owner = split("/", var.github_repository)[0]
}

provider "github" {
  owner = local.github_owner
  token = var.github_token
}
