resource "digitalocean_kubernetes_cluster" "kubernetes_cluster" {
  name    = "efuse-demo-k8s-cluster"
  region  = "nyc3"
  version = "1.21.5-do.0"
  tags    = ["efuse-demo"]

  node_pool {
    name       = "pool0"
    size       = "s-1vcpu-2gb"
    node_count = 2
    auto_scale = false
    tags       = ["efuse-demo"]
  }
}

resource "digitalocean_loadbalancer" "public" {
  name   = "efuse-demo"
  region = "nyc3"

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 30001
    target_protocol = "http"
  }

  healthcheck {
    port     = 30001
    protocol = "tcp"
  }

  droplet_ids = digitalocean_kubernetes_cluster.kubernetes_cluster.node_pool.0.nodes.*.droplet_id
}

resource "local_file" "k8s_config" {
  content         = digitalocean_kubernetes_cluster.kubernetes_cluster.kube_config[0].raw_config
  filename        = "${path.module}/../k8s_config"
  file_permission = "0600"
}
