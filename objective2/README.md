# Objective 2 - Implement path-based routing for a Kubernetes ingress
For this objective, you'll be deploying ingress-nginx to the k8s cluster and then deploying a couple of containers with some routing rules.

You will need to have [Helm](https://helm.sh/) installed (that's how we're deploying ingress-nginx) and you'll need the `loadbalancer_id` from terraform that we used in the previous objective.

To make things a bit less verbose, I created these temporary aliases that set the path to our kubeconfig:

```
# alias kubectl="kubectl --kubeconfig $PWD/../k8s_config"
# alias helm="helm --kubeconfig $PWD/../k8s_config"
```

## Install ingress-nginx - `ingress-nginx-values.yaml`
You'll be doing a pretty basic ingress-nginx install via Helm using the values inside of `ingress-nginx-values.yaml`. Before you run Helm, you'll need to edit `ingress-nginx-values.yaml` to set the value of the `kubernetes.digitalocean.com/load-balancer-id` annotation with the `loadbalancer_id` from terraform like we did in Objective 1.

I'm using the latest version of the ingress-nginx helm chart which, at the time of writing, is 4.0.16 (which maps to ingress-nginx version 1.1.1). I'm also deploying it to a new k8s namespace which is creatively named `ingress-nginx`.

```
# helm install ingress-nginx ingress-nginx/ingress-nginx --version 4.0.16 --namespace ingress-nginx --create-namespace -f ingress-nginx-values.yaml
```

Once it is done installing, you can check to make sure that it took ownership of the Digital Ocean load balancer by seeing if the `ingress-nginx-controller` service has an external IP with:

```
# kubectl get services
```

## `web-deployment.yaml`
For brevity's sake, I've included multiple k8s resources in these files. These include a `Deployment` very similar to the `Deployment` from Objective 1, a `ClusterIP` Service to expose the deployment, and an `Ingress` that configures routing to the deployed container via ingress-nginx.

This `Ingress` rule will route traffic from `efuse.nathan.chowning.me/*` to the deployment's nginx container.

> NOTE: If you've configured a hostname that's pointed to your Digial Ocean load balancer, you will need to update the value of `host` in the `Ingress` resource to match your desired hostname.

Apply this configuration and inspect the results with:

```
# kubectl apply -f web-deployment.yaml
# kubectl get deployments
# kubectl get services
# kubectl get ingress
```

> NOTE: When visiting other paths (e.g. `efuse.nathan.chowning.me/testing`), you will receive a 404. This isn't an improperly configured ingress rule. That 404 is coming from the nginx container. This threw me off for a minute.

## `whoami-deployment.yaml`
This file is configured almost identically to `web-deployment.yaml` except it is deploying the `containous/whoami` container and configuring a new `Ingress` rule to route `efuse.nathan.chowning.me/whoami` to the `containous/whoami` container.

> NOTE: If you've configured a hostname that's pointed to your Digial Ocean load balancer, you will need to update the value of `host` in the `Ingress` resource to match your desired hostname.

Apply this configuration and inspect the results the same way with:

```
# kubectl apply -f whoami-deployment.yaml
# kubectl get deployments
# kubectl get services
# kubectl get ingress
```

You should now be able to access this container via `efuse.nathan.chowning.me/whoami`. All other paths will continue to route to the default nginx container from `web-deployment.yaml`

## Cleanup
This is the last interactive objective so there's not a need to keep any of the resources around. You can just tear everything down with terraform:

```
# cd ../terraform
# terraform destroy
```
