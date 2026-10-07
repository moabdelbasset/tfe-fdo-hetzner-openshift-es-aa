resource "helm_release" "minio" {
  name       = var.minio_name
  namespace  = kubernetes_namespace.example.metadata[0].name
  repository = var.minio_chart_repo
  chart      = var.minio_type
  version    = var.minio_chart_version

  values = [
    yamlencode({
      global = {
        security = {
          allowInsecureImages = true
        }
      }
      image = {
        repository = var.minio_image_repo
      }
      console = {
        image = {
          repository = var.minio_console_image_repo
        }
      }
      mode           = "standalone"
      defaultBuckets = var.minio_bucket
      auth = {
        rootUser = var.minio_root_user
      }
      tls = {
        enabled = false
      }
      persistence = {
        storageClass = var.minio_storage_class
        size         = var.minio_storage_size
      }
    })
  ]

  set_sensitive = [
    {
      name  = "auth.rootPassword"
      value = var.minio_root_password
    }
  ]
}
