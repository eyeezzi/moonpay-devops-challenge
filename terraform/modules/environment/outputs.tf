output "deployer_service_account_email" {
  description = "Email of the GitHub Actions deployer service account"
  value       = google_service_account.deployer.email
}

output "app_runtime_service_account_email" {
  description = "Email of the GKE application runtime service account"
  value       = google_service_account.app_runtime.email
}

output "cloud_sql_connection_name" {
  description = "Cloud SQL instance connection name for Cloud SQL Auth Proxy"
  value       = google_sql_database_instance.app.connection_name
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

output "gke_cluster_name" {
  description = "GKE cluster name"
  value       = google_container_cluster.app.name
}

output "gke_cluster_location" {
  description = "GKE cluster location (zone)"
  value       = google_container_cluster.app.location
}

output "gke_namespace" {
  description = "Kubernetes namespace for production deployments (null for staging; PR previews use pr-<number>)"
  value       = var.gke_namespace
}
