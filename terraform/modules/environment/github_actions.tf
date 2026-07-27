locals {
  github_owner = split("/", var.github_repository)[0]
  github_repo  = split("/", var.github_repository)[1]

  gh = {
    gcp_service_account         = "${var.github_var_prefix}GCP_SERVICE_ACCOUNT"
    cloud_sql_connection_name   = "${var.github_var_prefix}CLOUD_SQL_CONNECTION_NAME"
    db_user                     = "${var.github_var_prefix}DB_USER"
    db_name                     = "${var.github_var_prefix}DB_NAME"
    db_password                 = "${var.github_var_prefix}DB_PASSWORD"
    gke_cluster_name            = "${var.github_var_prefix}GKE_CLUSTER_NAME"
    gke_cluster_location        = "${var.github_var_prefix}GKE_CLUSTER_LOCATION"
    app_runtime_gcp_sa          = "${var.github_var_prefix}APP_RUNTIME_GCP_SA"
  }
}

resource "github_actions_variable" "gcp_service_account" {
  repository    = local.github_repo
  variable_name = local.gh.gcp_service_account
  value         = google_service_account.deployer.email
}

resource "github_actions_variable" "cloud_sql_connection_name" {
  repository    = local.github_repo
  variable_name = local.gh.cloud_sql_connection_name
  value         = google_sql_database_instance.app.connection_name
}

resource "github_actions_variable" "db_user" {
  repository    = local.github_repo
  variable_name = local.gh.db_user
  value         = google_sql_user.app.name
}

resource "github_actions_variable" "db_name" {
  repository    = local.github_repo
  variable_name = local.gh.db_name
  value         = google_sql_database.app.name
}

resource "github_actions_secret" "db_password" {
  repository  = local.github_repo
  secret_name = local.gh.db_password
  value       = random_password.db.result
}

resource "github_actions_variable" "gke_cluster_name" {
  repository    = local.github_repo
  variable_name = local.gh.gke_cluster_name
  value         = google_container_cluster.app.name
}

resource "github_actions_variable" "gke_cluster_location" {
  repository    = local.github_repo
  variable_name = local.gh.gke_cluster_location
  value         = google_container_cluster.app.location
}

resource "github_actions_variable" "app_runtime_gcp_sa" {
  repository    = local.github_repo
  variable_name = local.gh.app_runtime_gcp_sa
  value         = google_service_account.app_runtime.email
}
