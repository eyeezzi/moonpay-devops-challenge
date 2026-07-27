resource "random_password" "db" {
  length  = 24
  special = false
}

resource "google_sql_database_instance" "app" {
  name             = var.cloud_sql_instance_name
  database_version = "POSTGRES_17"
  region           = var.region
  project          = var.project_id

  deletion_protection = var.cloud_sql_deletion_protection

  settings {
    tier              = var.cloud_sql_tier
    edition           = "ENTERPRISE"
    availability_type = "ZONAL"

    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
    }

    ip_configuration {
      ipv4_enabled = true
      ssl_mode     = "ENCRYPTED_ONLY"
    }
  }
}

resource "google_sql_database" "app" {
  name     = var.db_name
  instance = google_sql_database_instance.app.name
  project  = var.project_id
}

resource "google_sql_user" "app" {
  name     = var.db_user
  instance = google_sql_database_instance.app.name
  project  = var.project_id
  password = random_password.db.result
}
