provider "google" {
  project = var.project_id
  region  = var.region
}

provider "github" {
  owner = local.github_owner
  token = var.github_token
}
