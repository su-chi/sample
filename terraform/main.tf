terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }

  backend "s3" {
    endpoint                    = "nyc3.digitaloceanspaces.com"
    key                         = "efuse/terraform.tfstate"
    bucket                      = "nchowning-tf-state"
    region                      = "us-east-1"  # lol
    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }
}

resource "digitalocean_kubernetes_cluster" "kubernetes_cluster" {
  name = "efuse-demo-k8s-cluster"
  region = "nyc3"
  version = "1.21.5-do.0"
  tags = ["efuse-demo"]

  node_pool {
    name = "pool0"
    size = "s-1vcpu-2gb"
    node_count = 2
    auto_scale = false
    tags = ["efuse-demo"]
  }
}

resource "local_file" "k8s_config" {
  content = digitalocean_kubernetes_cluster.kubernetes_cluster.kube_config[0].raw_config
  filename = "${path.module}/../k8s_config"
  file_permission = "0600"
}
