resource "helm_release" "postgresql" {
  name       = var.db_name
  namespace  = kubernetes_namespace.example.metadata[0].name
  repository = var.db_chart_repo
  chart      = var.db_type
  version    = var.db_chart_version

  values = [
    yamlencode({
      auth = {
        username = var.db_username
        database = var.db_database
      }
      primary = {
        persistence = {
          storageClass = var.db_storage_class
          size         = var.db_storage_size
        }
      }
    })
  ]

  set_sensitive = [
    {
      name  = "auth.password"
      value = var.db_password
    }
  ]
}
