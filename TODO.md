# TODO
- [x] Fork moonpay/develops-challenge and work off my fork.
- [x] Check that app runs locally and fix any issues.
- [x] Build working container for the NextJS app.
    - [x] Create Dockerfile to build the NextJS app image.
- [ ] CI/CD pipeline to deploy the app.
    - [ ] Create Helm chart for app deployment with preview and production overrides.
    - [ ] Create Github Actions Workflow to build and deploy PRs
        - run migration on staging cloudsql instance
        - deploy to k8s manifests to pr namespace in cluster
    - [ ] Create Github Actions Workflow to build and deploy merges to main
        - run migration on prod cloudsql instance
        - deploy k8s manifests to 'prod' namespace in cluster.
- [ ] IAC to run the app.
    - [ ] Google Artefact Registry to store the application image
    - [ ] Create CloudSQL instance for the database
        - make private, no public IP.
    - [ ] Create GKE cluster to run the application image
    - [ ] Move Terraform state to a remote GCS bucket

## Setup commands
```
docker context ls
docker context use podman
volta install node
volta list
```

Auth with google for terraform iac
    gcloud auth application-default login
    gcloud config set project YOUR_PROJECT_ID
Create infra
    cd terraform
    cp terraform.tfvars.example terraform.tfvars   # fill in project_id
    terraform init
    terraform plan
    terraform apply

