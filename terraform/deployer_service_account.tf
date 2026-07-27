resource "google_service_account" "deployer" {
  account_id   = "github-deployer"
  display_name = "GitHub Actions deployer service account"

  depends_on = [google_project_service.required]
}

locals {
  deployer_roles = toset([
    "roles/artifactregistry.writer",
    "roles/container.developer",
    "roles/iam.serviceAccountUser",
    "roles/cloudsql.client",
  ])
}

resource "google_project_iam_member" "deployer" {
  for_each = local.deployer_roles

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.deployer.email}"
}
