locals {
  github_owner = split("/", var.github_repository)[0]
  github_repo  = split("/", var.github_repository)[1]
}

resource "github_actions_variable" "gcp_wif_provider" {
  repository    = local.github_repo
  variable_name = "GCP_WIF_PROVIDER"
  value         = google_iam_workload_identity_pool_provider.github.name
}

resource "github_actions_variable" "gcp_service_account" {
  repository    = local.github_repo
  variable_name = "GCP_SERVICE_ACCOUNT"
  value         = google_service_account.deployer.email
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
  value         = "${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_registry_repository_id}"
}

resource "github_actions_variable" "cloud_sql_connection_name" {
  repository    = local.github_repo
  variable_name = "CLOUD_SQL_CONNECTION_NAME"
  value         = google_sql_database_instance.app.connection_name
}

resource "github_actions_variable" "db_user" {
  repository    = local.github_repo
  variable_name = "DB_USER"
  value         = google_sql_user.app.name
}

resource "github_actions_variable" "db_name" {
  repository    = local.github_repo
  variable_name = "DB_NAME"
  value         = google_sql_database.app.name
}

resource "github_actions_secret" "db_password" {
  repository = local.github_repo
  secret_name = "DB_PASSWORD"
  value       = random_password.db.result
}
