output "deployer_service_account_email" {
  description = "Email of the GitHub Actions deployer service account"
  value       = module.environment.deployer_service_account_email
}

output "app_runtime_service_account_email" {
  description = "Email of the GKE application runtime service account"
  value       = module.environment.app_runtime_service_account_email
}

output "cloud_sql_connection_name" {
  description = "Cloud SQL instance connection name for Cloud SQL Auth Proxy"
  value       = module.environment.cloud_sql_connection_name
}

output "gke_cluster_name" {
  description = "GKE cluster name"
  value       = module.environment.gke_cluster_name
}

output "gke_cluster_location" {
  description = "GKE cluster location (zone)"
  value       = module.environment.gke_cluster_location
}

output "database_password" {
  description = "Application database password"
  value       = module.environment.database_password
  sensitive   = true
}
