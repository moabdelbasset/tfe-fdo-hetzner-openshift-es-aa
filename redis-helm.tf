resource "helm_release" "redis" {
  name       = var.redis_name
  namespace  = kubernetes_namespace.example.metadata[0].name
  repository = var.redis_chart_repo
  chart      = var.redis_type
  version    = var.redis_chart_version

  values = [
    yamlencode({
      architecture = "standalone"
      auth = {
        enabled = true
      }
      tls = {
        enabled = false
      }
      master = {
        persistence = {
          storageClass = var.redis_storage_class
          size         = var.redis_storage_size
        }
      }
    })
  ]

  set_sensitive = [
    {
      name  = "auth.password"
      value = var.redis_password
    }
  ]
}
