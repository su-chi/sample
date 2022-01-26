# Objective 3 - Implement a GitHub Actions deployment process
I've implemented a super basic deployment method using github actions. This job only needs one repo secret - `DIGITALOCEAN_ACCESS_TOKEN`.

When a push is made to the `main` branch and if a file matching `objective2/*-deployment.yaml` was modified, the job will run. The job will pull down the repo code, install the `doctl` client to interact with Digital Ocean, saves the kubeconfig for the k8s cluster, and then deploys `objective2/web-deployment.yaml` and `objective2/whoami-deployment.yaml`.

This is good as a proof of concept but in a real production environment, I would want to build a more robust workflow, add tests/validations that would run, require peer review, and if all of that passes, the job could deploy.
