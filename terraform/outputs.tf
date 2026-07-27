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

output "artifact_registry_url" {
  description = "Docker image URL prefix for Artifact Registry"
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_registry_repository_id}/${var.artifact_registry_image_name}"
}

output "workload_identity_provider" {
  description = "Full Workload Identity Provider resource name for google-github-actions/auth"
  value       = google_iam_workload_identity_pool_provider.github.name
}

output "deployer_service_account_email" {
  description = "Email of the GitHub Actions deployer service account"
  value       = google_service_account.deployer.email
}

output "cloud_sql_connection_name" {
  description = "Cloud SQL instance connection name for Cloud SQL Auth Proxy"
  value       = google_sql_database_instance.app.connection_name
}

output "gke_cluster_name" {
  description = "GKE cluster name"
  value       = google_container_cluster.app.name
}

output "gke_cluster_location" {
  description = "GKE cluster location (zone)"
  value       = google_container_cluster.app.location
}

output "app_runtime_service_account_email" {
  description = "Email of the GKE application runtime service account"
  value       = google_service_account.app_runtime.email
}

output "cloud_sql_instance_name" {
  description = "Cloud SQL instance name"
  value       = google_sql_database_instance.app.name
}

output "database_name" {
  description = "Application database name"
  value       = google_sql_database.app.name
}

output "database_user" {
  description = "Application database user"
  value       = google_sql_user.app.name
}

output "database_password" {
  description = "Application database password"
  value       = random_password.db.result
  sensitive   = true
}
