# How to use
To work through this work sample repository, you will need the following:

- A Digital Ocean account
- terraform
- helm
- kubectl

To setup the environment, follow the steps outlined in the `terraform` directory's README.

# Objectives
Each Objective has a directory containing files relevant to completing that objective as well as a README file explaining how to use those files.

# Additional Considerations
I designed this work sample with a few goals in mind:

- Make it as self contained as possible: I wanted to be able to easily build and teardown the entire environment.
- Experiment with the Digital Ocean cloud offerings & terraform provider: I have a few Digital Ocean droplets & use them to manage my personal DNS.
- Automate as much as possible: Manual actions are the worst.
- Document my solutions and process as much as possible.

I feel as though I've accomplished these goals and that this is a good representation of my skillset.

# Connecting with k9s
Easy little one-liner to connect to the k8s cluster with k9s via the k9s docker container (if you don't already have k9s installed):

```
docker run --rm -it -v $PWD/k8s_config:/root/.kube/config quay.io/derailed/k9s:latest
```
