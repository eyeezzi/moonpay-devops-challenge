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
