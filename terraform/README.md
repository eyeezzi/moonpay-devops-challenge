# Terraform Infrastructure

Multi-environment GCP infrastructure for the MoonPay DevOps challenge. Resources are split into three independent Terraform stacks that share a GCP project, APIs, and Artifact Registry.

## Layout

```
terraform/
  modules/environment/   # Reusable module: GKE, Cloud SQL, SAs, WIF binding, GitHub vars
  shared/              # Project-level: APIs, Artifact Registry, WIF pool/provider
  staging/             # Staging: moonpay cluster, moonpay-db, github-deployer SA
  production/          # Production: moonpay-prod cluster, moonpay-prod-db, github-deployer-prod SA
```

## What is shared vs environment-specific

| Resource | shared | staging | production |
|----------|--------|---------|------------|
| GCP APIs | yes | | |
| Artifact Registry (`moonpay-app`) | yes | | |
| WIF pool + OIDC provider | yes | | |
| GKE cluster | | `moonpay` (us-central1-a) | `moonpay-prod` (us-central1-b) |
| Cloud SQL | | `moonpay-db` | `moonpay-prod-db` |
| Deployer SA | | `github-deployer` | `github-deployer-prod` |
| App runtime SA | | `app-runtime` | `app-runtime-prod` |

## GitHub Actions variables

**Shared** (set by `shared/`):

- `GCP_PROJECT_ID`, `GCP_REGION`, `ARTIFACT_REGISTRY_URL`, `GCP_WIF_PROVIDER`

**Staging** (set by `staging/`, consumed by `.github/workflows/pr-image.yml`):

- `GCP_SERVICE_ACCOUNT`, `CLOUD_SQL_CONNECTION_NAME`, `DB_USER`, `DB_NAME`, `DB_PASSWORD`
- `GKE_CLUSTER_NAME`, `GKE_CLUSTER_LOCATION`, `APP_RUNTIME_GCP_SA`

**Production** (set by `production/`, for future prod deploy workflow):

- `PROD_GCP_SERVICE_ACCOUNT`, `PROD_CLOUD_SQL_CONNECTION_NAME`, `PROD_DB_USER`, `PROD_DB_NAME`, `PROD_DB_PASSWORD`
- `PROD_GKE_CLUSTER_NAME`, `PROD_GKE_CLUSTER_LOCATION`, `PROD_APP_RUNTIME_GCP_SA`

Production workflows reuse the shared `GCP_WIF_PROVIDER` and select the prod deployer SA via `PROD_GCP_SERVICE_ACCOUNT`.

## Prerequisites

```bash
gcloud auth application-default login
gcloud config set project YOUR_PROJECT_ID
```

Each stack needs a `terraform.tfvars` (see `terraform.tfvars.example` in each directory). The shared stack requires `project_id` and `github_token`; staging and production only need `github_token` (and optionally `github_repository`).

## Apply order

Stacks must be applied in order because staging and production read shared outputs via remote state:

```bash
cd terraform/shared
cp terraform.tfvars.example terraform.tfvars   # fill in project_id and github_token
terraform init
terraform apply

cd ../staging
cp terraform.tfvars.example terraform.tfvars   # fill in github_token
terraform init
terraform apply

cd ../production
cp terraform.tfvars.example terraform.tfvars   # fill in github_token
terraform init
terraform apply
```

Each stack maintains its own state file (`terraform.tfstate`). Staging and production can be applied independently once shared has been applied.

## State migration (from flat root)

If upgrading from the original single-root layout, use `terraform state mv` to move resources without destroy/recreate. A backup of the pre-migration state is kept at `terraform.tfstate.pre-migration.backup`.

### Move to `shared/`

```bash
cd terraform/shared
terraform init

OLD="../terraform.tfstate.pre-migration.backup"
NEW="terraform.tfstate"

# APIs
for api in artifactregistry.googleapis.com compute.googleapis.com container.googleapis.com \
           iam.googleapis.com iamcredentials.googleapis.com sqladmin.googleapis.com sts.googleapis.com; do
  terraform state mv -state="$OLD" -state-out="$NEW" \
    "google_project_service.required[\"$api\"]" "google_project_service.required[\"$api\"]"
done

terraform state mv -state="$OLD" -state-out="$NEW" 'google_artifact_registry_repository.app' 'google_artifact_registry_repository.app'
terraform state mv -state="$OLD" -state-out="$NEW" 'google_iam_workload_identity_pool.github' 'google_iam_workload_identity_pool.github'
terraform state mv -state="$OLD" -state-out="$NEW" 'google_iam_workload_identity_pool_provider.github' 'google_iam_workload_identity_pool_provider.github'
terraform state mv -state="$OLD" -state-out="$NEW" 'github_actions_variable.gcp_wif_provider' 'github_actions_variable.gcp_wif_provider'
terraform state mv -state="$OLD" -state-out="$NEW" 'github_actions_variable.gcp_project_id' 'github_actions_variable.gcp_project_id'
terraform state mv -state="$OLD" -state-out="$NEW" 'github_actions_variable.gcp_region' 'github_actions_variable.gcp_region'
terraform state mv -state="$OLD" -state-out="$NEW" 'github_actions_variable.artifact_registry_url' 'github_actions_variable.artifact_registry_url'

terraform apply   # persists outputs to state
```

### Move to `staging/`

```bash
cd terraform/staging
terraform init

OLD="../terraform.tfstate.pre-migration.backup"
NEW="terraform.tfstate"

terraform state mv -state="$OLD" -state-out="$NEW" 'google_container_cluster.app' 'module.environment.google_container_cluster.app'
terraform state mv -state="$OLD" -state-out="$NEW" 'google_container_node_pool.app' 'module.environment.google_container_node_pool.app'
terraform state mv -state="$OLD" -state-out="$NEW" 'google_sql_database_instance.app' 'module.environment.google_sql_database_instance.app'
terraform state mv -state="$OLD" -state-out="$NEW" 'google_sql_database.app' 'module.environment.google_sql_database.app'
terraform state mv -state="$OLD" -state-out="$NEW" 'google_sql_user.app' 'module.environment.google_sql_user.app'
terraform state mv -state="$OLD" -state-out="$NEW" 'random_password.db' 'module.environment.random_password.db'
terraform state mv -state="$OLD" -state-out="$NEW" 'google_service_account.deployer' 'module.environment.google_service_account.deployer'
terraform state mv -state="$OLD" -state-out="$NEW" 'google_service_account.app_runtime' 'module.environment.google_service_account.app_runtime'

for role in "roles/artifactregistry.writer" "roles/container.developer" "roles/iam.serviceAccountUser" "roles/cloudsql.client"; do
  terraform state mv -state="$OLD" -state-out="$NEW" \
    "google_project_iam_member.deployer[\"$role\"]" "module.environment.google_project_iam_member.deployer[\"$role\"]"
done

for role in "roles/artifactregistry.reader" "roles/cloudsql.client"; do
  terraform state mv -state="$OLD" -state-out="$NEW" \
    "google_project_iam_member.app_runtime[\"$role\"]" "module.environment.google_project_iam_member.app_runtime[\"$role\"]"
done

terraform state mv -state="$OLD" -state-out="$NEW" 'google_service_account_iam_member.app_workload_identity' 'module.environment.google_service_account_iam_member.app_workload_identity'
terraform state mv -state="$OLD" -state-out="$NEW" 'google_service_account_iam_member.github_wif' 'module.environment.google_service_account_iam_member.github_wif'
terraform state mv -state="$OLD" -state-out="$NEW" 'github_actions_variable.gcp_service_account' 'module.environment.github_actions_variable.gcp_service_account'
terraform state mv -state="$OLD" -state-out="$NEW" 'github_actions_variable.cloud_sql_connection_name' 'module.environment.github_actions_variable.cloud_sql_connection_name'
terraform state mv -state="$OLD" -state-out="$NEW" 'github_actions_variable.db_user' 'module.environment.github_actions_variable.db_user'
terraform state mv -state="$OLD" -state-out="$NEW" 'github_actions_variable.db_name' 'module.environment.github_actions_variable.db_name'
terraform state mv -state="$OLD" -state-out="$NEW" 'github_actions_secret.db_password' 'module.environment.github_actions_secret.db_password'
terraform state mv -state="$OLD" -state-out="$NEW" 'github_actions_variable.gke_cluster_name' 'module.environment.github_actions_variable.gke_cluster_name'
terraform state mv -state="$OLD" -state-out="$NEW" 'github_actions_variable.gke_cluster_location' 'module.environment.github_actions_variable.gke_cluster_location'
terraform state mv -state="$OLD" -state-out="$NEW" 'github_actions_variable.app_runtime_gcp_sa' 'module.environment.github_actions_variable.app_runtime_gcp_sa'
```

After migration, run `terraform plan` in shared and staging — both should show no infrastructure changes.
