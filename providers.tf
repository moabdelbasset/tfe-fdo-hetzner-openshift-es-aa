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
   
  }
}

provider "kubernetes" {
  config_path = var.openshift_config_path
  config_context = var.openshift_config_context
}
