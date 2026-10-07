terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.3.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.3.0"
    }
    acme = {
      source  = "vancluever/acme"
      version = "~> 2.36.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.27"
    }

  }
}

provider "kubernetes" {
  config_path    = var.openshift_config_path
  config_context = var.openshift_config_context
}


provider "acme" {
  server_url = var.acme_server_url
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "helm" {
  kubernetes = {
    config_path    = var.openshift_config_path
    config_context = var.openshift_config_context
  }
}
