terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "iiflex_token" {}

provider "digitalocean" {
  token = var.iiflex_token
}


variable "k8s_name" {}
variable "region" {}

resource "digitalocean_kubernetes_cluster" "genieacs" {
  name   = var.k8s_name
  region = var.region
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.24.4-do.0"


  node_pool {
    name       = "default"
    size       = "s-2vcpu-4gb"
    node_count = 3
  }
}



resource "local_file" "kube_config" {
  content  = digitalocean_kubernetes_cluster.genieacs.kube_config.0.raw_config
  filename = "kube_config.yaml"
}


