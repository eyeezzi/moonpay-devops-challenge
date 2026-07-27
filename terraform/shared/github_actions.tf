locals {
  github_repo = split("/", var.github_repository)[1]
}

resource "github_actions_variable" "gcp_wif_provider" {
  repository    = local.github_repo
  variable_name = "GCP_WIF_PROVIDER"
  value         = google_iam_workload_identity_pool_provider.github.name
}

resource "github_actions_variable" "gcp_project_id" {
  repository    = local.github_repo
  variable_name = "GCP_PROJECT_ID"
  value         = var.project_id
}

resource "github_actions_variable" "gcp_region" {
  repository    = local.github_repo
  variable_name = "GCP_REGION"
  value         = var.region
}

resource "github_actions_variable" "artifact_registry_url" {
  repository    = local.github_repo
  variable_name = "ARTIFACT_REGISTRY_URL"
  value         = "${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_registry_repository_id}/${var.artifact_registry_image_name}"
}
