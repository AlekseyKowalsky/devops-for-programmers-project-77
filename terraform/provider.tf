terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    acme = {
      source  = "vancluever/acme"
      version = "~> 2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.0"
    }
    datadog = {
      source = "DataDog/datadog"
      version = "3.34.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

provider "acme" {
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
}

provider "tls" {}

provider "datadog" {
  api_url = "https://api.datadoghq.eu/"
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}