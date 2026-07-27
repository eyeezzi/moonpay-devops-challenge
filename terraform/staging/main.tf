data "terraform_remote_state" "shared" {
  backend = "local"

  config = {
    path = abspath("${path.module}/../shared/terraform.tfstate")
  }
}

provider "google" {
  project = data.terraform_remote_state.shared.outputs.project_id
  region  = data.terraform_remote_state.shared.outputs.region
}

locals {
  github_owner = split("/", var.github_repository)[0]
}

provider "github" {
  owner = local.github_owner
  token = var.github_token
}

module "environment" {
  source = "../modules/environment"

  project_id                  = data.terraform_remote_state.shared.outputs.project_id
  region                      = data.terraform_remote_state.shared.outputs.region
  environment                 = "staging"
  github_repository           = var.github_repository
  github_token                = var.github_token
  github_var_prefix           = ""
  workload_identity_pool_name = data.terraform_remote_state.shared.outputs.workload_identity_pool_name
  workload_identity_provider  = data.terraform_remote_state.shared.outputs.workload_identity_provider

  gke_cluster_name        = "moonpay"
  gke_zone                = "us-central1-a"
  cloud_sql_instance_name = "moonpay-db"
  deployer_sa_account_id    = "github-deployer"
  app_runtime_sa_account_id = "app-runtime"
}
