terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }

  backend "s3" {
    endpoint                    = "nyc3.digitaloceanspaces.com"
    key                         = "efuse/terraform.tfstate"
    bucket                      = "nchowning-tf-state"
    region                      = "us-east-1" # lol
    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }
}
