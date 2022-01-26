resource "digitalocean_domain" "domain" {
  name = var.hostname
}

resource "digitalocean_record" "a" {
  domain = digitalocean_domain.domain.id
  type   = "A"
  name   = "@"
  value  = digitalocean_loadbalancer.public.ip
}
