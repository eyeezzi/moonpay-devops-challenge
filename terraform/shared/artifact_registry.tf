resource "google_artifact_registry_repository" "app" {
  location      = var.region
  repository_id = var.artifact_registry_repository_id
  format        = "DOCKER"
  description   = "Container images for moonpay-devops-challenge"

  depends_on = [google_project_service.required]
}
