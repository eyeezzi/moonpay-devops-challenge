output "project_id" {
  description = "GCP project ID"
  value       = var.project_id
}

output "region" {
  description = "GCP region"
  value       = var.region
}

output "artifact_registry_repository" {
  description = "Full Artifact Registry repository resource name"
  value       = google_artifact_registry_repository.app.name
}

output "artifact_registry_repository_id" {
  description = "Artifact Registry repository ID"
  value       = var.artifact_registry_repository_id
}

output "artifact_registry_image_name" {
  description = "Docker image name within the Artifact Registry repository"
  value       = var.artifact_registry_image_name
}

output "artifact_registry_url" {
  description = "Docker image URL prefix for Artifact Registry"
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_registry_repository_id}/${var.artifact_registry_image_name}"
}

output "workload_identity_provider" {
  description = "Full Workload Identity Provider resource name for google-github-actions/auth"
  value       = google_iam_workload_identity_pool_provider.github.name
}

output "workload_identity_pool_name" {
  description = "Full Workload Identity Pool resource name"
  value       = google_iam_workload_identity_pool.github.name
}
