# Objective 1 - Deploy a containerized application in Kubernetes
I took a pretty basic approach to deploying the `nginx` container to my cluster & serving it. To deploy this solution, you'll only need `kubectl` and the `loadbalancer_id` from the Terraform environment setup. `k9s` is also useful for inspecting the cluster interactively.

To make things a bit less verbose, I created this temporary alias that sets the path to our kubeconfig:

```
# alias kubectl="kubectl --kubeconfig $PWD/../k8s_config"
```

## `web-deployment.yaml`
This is the main container deployment. It creates a deployment named `web-deployment` with 2 replicas in the `default` k8s namespace and uses the `nginx:latest` container image. I've also added some basic anti affinity rules to this deployment to (hopefully) spread the replicas across nodes. You can apply this config to the cluster with:

```
# kubectl apply -f web-deployment.yaml
```

To inspect the state & make sure it was deployed properly, you can use:

```
# kubectl get deployments
# kubectl get pods
```

If you want to check that each pod is running on a separate node, you can do:

```
# kubectl describe pod <INSERT POD NAME HERE>|grep "^Node:"
```

## `web-service.yaml`
Now that our container is deployed to the cluster, we need to wire it up to our load balancer so it can be accessed. Open up the `web-service.yaml` file and set the value of the `kubernetes.digitalocean.com/load-balancer-id` annotation with the `loadbalancer_id` from terraform.

> tldr Digital Ocean's kubernetes offering will automatically create a load balancer for you when you create a `LoadBalancer` k8s Service but it takes a while to build and for the purposes of this exercise, I didn't want to have to import the load balancer resource into terraform to configure DNS for the domain. If you set the `kubernetes.digitalocean.com/load-balancer-id` to a valid Digital Ocean load balancer ID, it will take ownership of that existing load balancer rather than creating a new one. That's actually part of the process that Digital Ocean recommends when migrating a load balancer... which we'll be doing later!

The rest of this file is pretty straight-forward. It creates a `LoadBalancer` k8s Service named `web-service` then points to port 80 on our nginx containers. After setting the load-balancer-id, you can apply this config and check the state with:

```
# kubectl apply -f web-service.yaml
# kubectl get services
```

The output from that last command should show you the external IP address for the load balancer. Sometimes it takes a few seconds for k8s to take ownership of the load balancer. If it doesn't show up at first, just run `kubectl get services` again after a few seconds.

You should now be able to access the nginx default page at that external IP address as well as the domain configured for this example (for me, that's `efuse.nathan.chowning.me`)

## Cleanup
Since the k8s cluster is managing the Digital Ocean load balancer, if we just delete the `web-service` k8s Service, that will delete the Digital Ocean load balancer (via a finalizer) then we'd have to fix DNS etc... and that's no fun. To get around this, we can configure the `web-service` to disown the Digital Ocean load balancer. In `web-service.yaml` change the value of the `service.kubernetes.io/do-loadbalancer-disown` annotation to `"true"` then run `kubectl apply -f web-service.yaml`.

Now that the Digital Ocean load balancer is disowned again, we can clean things up:

```
# kubectl delete -f web-service.yaml -f web-deployment.yaml
```

Time for Objective 2!
