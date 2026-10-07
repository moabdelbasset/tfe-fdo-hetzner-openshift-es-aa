resource "kubernetes_namespace" "example" {
  metadata {
    annotations = {
      name = var.namespace
    }
    labels = {
      mylabel = "tfe"
    }
    name = var.namespace
  }
}
