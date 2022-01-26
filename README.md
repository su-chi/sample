# Objectives
Each Objective has a directory containing files relevant to completing that objective as well as a README file explaining how to use those files.

# Connecting with k9s
Easy little one-liner to connect to the k8s cluster with k9s via the k9s docker container (if you don't already have k9s installed):

```
docker run --rm -it -v $PWD/k8s_config:/root/.kube/config quay.io/derailed/k9s:latest
```
