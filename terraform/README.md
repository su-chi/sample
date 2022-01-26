# Environment Setup - `./terraform`
The initial setup for this environment will use Terraform (v1.1.4) & the [digitalocean provider](https://registry.terraform.io/providers/digitalocean/digitalocean/2.17.0) to build a tiny Kubernetes cluster (2 small nodes), public load balancer, and point a specified domain at the load balancer.

The following enviornment variables will need to be set:
- `DIGITALOCEAN_TOKEN` - Digital Ocean API token
- `AWS_ACCESS_KEY_ID` - DO Spaces access key (if you're using a remote backend)
- `AWS_SECRET_ACCESS_KEY` - DO Spaces access secret (if you're using a remote backend)

The `AWS_*` environment variables are for the terraform remote backend. You will need to create that Digital Ocean Space in their control panel manually. To change the remote backend settings, just edit the `backend` section in `main.tf`. If you don't want to use a remote backend, you can just remove the `backend` section completely.

With the environment variables set and your remote backend config sorted, you should be able to just:

```
# terraform apply
```

Building the cluster and load balancer will take a few minutes.

Terraform will create a `k8s_config` file in the root of the repository for you to access the cluster and output a `loadbalancer_id` at the end. You'll want to save the `loadbalancer_id` value for later. If you lose it, you can just run `terraform output` from within the `terraform` directory.
