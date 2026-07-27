variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region for regional resources"
  type        = string
}

variable "environment" {
  description = "Environment name (staging or production)"
  type        = string
}

variable "github_repository" {
  description = "GitHub repository allowed to authenticate via Workload Identity Federation (owner/repo)"
  type        = string
}

variable "github_token" {
  description = "GitHub PAT for managing Actions variables/secrets (repo scope)"
  type        = string
  sensitive   = true
}

variable "github_var_prefix" {
  description = "Prefix for GitHub Actions variable/secret names (e.g. PROD_ for production)"
  type        = string
  default     = ""
}

variable "workload_identity_pool_name" {
  description = "Full resource name of the shared Workload Identity pool"
  type        = string
}

variable "workload_identity_provider" {
  description = "Full resource name of the shared Workload Identity provider"
  type        = string
}

variable "cloud_sql_instance_name" {
  description = "Cloud SQL instance name"
  type        = string
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
}

variable "gke_zone" {
  description = "GKE cluster zone"
  type        = string
}

variable "gke_node_machine_type" {
  description = "Machine type for GKE node pool"
  type        = string
  default     = "e2-medium"
}

variable "gke_namespace" {
  description = "Kubernetes namespace for production Workload Identity binding (staging PR namespaces are managed by CI)"
  type        = string
  default     = null
}

variable "gke_service_account_name" {
  description = "Kubernetes service account name for application pods"
  type        = string
  default     = "app"
}

variable "deployer_sa_account_id" {
  description = "Account ID for the GitHub Actions deployer service account"
  type        = string
}

variable "app_runtime_sa_account_id" {
  description = "Account ID for the GKE application runtime service account"
  type        = string
}
