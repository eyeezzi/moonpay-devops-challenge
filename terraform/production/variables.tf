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
