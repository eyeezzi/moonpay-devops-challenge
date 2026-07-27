variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region for regional resources"
  type        = string
  default     = "us-central1"
}

variable "github_repository" {
  description = "GitHub repository allowed to authenticate via Workload Identity Federation (owner/repo)"
  type        = string
  default     = "eyeezzi/moonpay-devops-challenge"
}

variable "github_token" {
  description = "GitHub PAT for managing Actions variables/secrets (repo scope)"
  type        = string
  sensitive   = true
}

variable "artifact_registry_repository_id" {
  description = "Artifact Registry repository ID for Docker images"
  type        = string
  default     = "moonpay-app"
}

variable "artifact_registry_image_name" {
  description = "Docker image name within the Artifact Registry repository"
  type        = string
  default     = "app"
}

variable "cloud_sql_instance_name" {
  description = "Cloud SQL instance name"
  type        = string
  default     = "moonpay-db"
}

variable "cloud_sql_tier" {
  description = "Cloud SQL machine tier"
  type        = string
  default     = "db-f1-micro"
}

variable "cloud_sql_deletion_protection" {
  description = "Prevent accidental deletion of the Cloud SQL instance"
  type        = bool
  default     = false
}

variable "db_name" {
  description = "Application database name"
  type        = string
  default     = "currencies"
}

variable "db_user" {
  description = "Application database user"
  type        = string
  default     = "app"
}

variable "gke_cluster_name" {
  description = "GKE cluster name"
  type        = string
  default     = "moonpay"
}

variable "gke_zone" {
  description = "GKE cluster zone"
  type        = string
  default     = "us-central1-a"
}

variable "gke_node_machine_type" {
  description = "Machine type for GKE node pool"
  type        = string
  default     = "e2-medium"
}

variable "gke_namespace" {
  description = "Kubernetes namespace for application deployments"
  type        = string
  default     = "moonpay"
}

variable "gke_service_account_name" {
  description = "Kubernetes service account name for application pods"
  type        = string
  default     = "app"
}
