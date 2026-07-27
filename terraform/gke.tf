resource "google_container_cluster" "app" {
  name     = var.gke_cluster_name
  location = var.gke_zone

  remove_default_node_pool = true
  initial_node_count       = 1

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  release_channel {
    channel = "REGULAR"
  }

  depends_on = [google_project_service.required]
}

resource "google_container_node_pool" "app" {
  name     = "${var.gke_cluster_name}-pool"
  location = var.gke_zone
  cluster  = google_container_cluster.app.name

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  node_config {
    machine_type = var.gke_node_machine_type
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  depends_on = [google_container_cluster.app]
}
