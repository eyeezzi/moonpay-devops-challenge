resource "google_service_account" "app_runtime" {
  account_id   = "app-runtime"
  display_name = "GKE application runtime service account"

  depends_on = [google_project_service.required]
}

locals {
  app_runtime_roles = toset([
    "roles/artifactregistry.reader",
    "roles/cloudsql.client",
  ])
}

resource "google_project_iam_member" "app_runtime" {
  for_each = local.app_runtime_roles

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.app_runtime.email}"
}

resource "google_service_account_iam_member" "app_workload_identity" {
  service_account_id = google_service_account.app_runtime.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[${var.gke_namespace}/${var.gke_service_account_name}]"
}
