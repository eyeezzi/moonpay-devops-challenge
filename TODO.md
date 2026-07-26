# TODO
- [x] Fork moonpay/develops-challenge and work off my fork.
- [ ] Check that app runs locally and fix any issues.
- [ ] Build working container for the NextJS app.
    - [ ] Create Dockerfile to build the NextJS app image.
- [ ] CI/CD pipeline to deploy the app.
    - [ ] Create Github Actions Workflow to build and deploy PRs
    - [ ] Create Github Actions Workflow to build and deploy merges to main
- [ ] IAC to run the app.
    - [ ] Google GCS repository to store the application image
    - [ ] Create CloudSQL instance for the database
    - [ ] Create CloudRun app to run the application image

## Setup commands
```
docker context ls
docker context use podman
volta install node
volta list
```
