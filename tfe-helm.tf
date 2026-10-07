locals {
  tfe_namespace = kubernetes_namespace.example.metadata[0].name
}

# Pull secret for images.releases.hashicorp.com (username "terraform", password = license)
resource "kubernetes_secret_v1" "tfe_image_pull" {
  metadata {
    name      = var.tfe_image_pull_secret_name
    namespace = local.tfe_namespace
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        (var.registry_images_url) = {
          auth = base64encode("terraform:${var.tfe_license}")
        }
      }
    })
  }
}

resource "helm_release" "tfe" {
  name            = var.tfe_name
  repository      = var.tfe_chart_repo
  chart           = var.tfe_type
  namespace       = local.tfe_namespace
  version         = var.tfe_chart_version
  cleanup_on_fail = true
  timeout         = var.helm_timeout

  values = [
    templatefile("${path.module}/overrides.tpl.yaml", {
      replica_count       = var.tfe_replica_count
      registry_images_url = var.registry_images_url
      tfe_release         = var.tfe_release
      image_pull_secret   = kubernetes_secret_v1.tfe_image_pull.metadata[0].name
      fqdn                = local.fqdn
      enc_password        = var.tfe_encryption_password
      tfe_license         = var.tfe_license
      pg_address          = "${helm_release.postgresql.name}-postgresql.${local.tfe_namespace}.svc:5432"
      pg_dbname           = var.db_database
      pg_user             = var.db_username
      pg_password         = var.db_password
      s3_bucket           = var.minio_bucket
      s3_bucket_key       = var.minio_root_user
      s3_bucket_secret    = var.minio_root_password
      s3_endpoint         = "http://${helm_release.minio.name}.${local.tfe_namespace}.svc:9000"
      redis_host          = "${helm_release.redis.name}-master.${local.tfe_namespace}.svc"
      redis_port          = "6379"
      redis_password      = var.redis_password
      tls_secret_name     = kubernetes_secret_v1.tfe_tls.metadata[0].name
      ca_cert_data        = base64encode(acme_certificate.certificate.issuer_pem)
    })
  ]
}

# Passthrough Route so the OpenShift router forwards tfe.<domain> to TFE (TLS ends in the TFE pod)
resource "kubernetes_manifest" "tfe_route" {
  manifest = {
    apiVersion = "route.openshift.io/v1"
    kind       = "Route"
    metadata = {
      name      = "terraform-enterprise"
      namespace = local.tfe_namespace
    }
    spec = {
      host = local.fqdn
      to = {
        kind = "Service"
        name = "terraform-enterprise"
      }
      port = {
        targetPort = "https-port"
      }
      tls = {
        termination                   = "passthrough"
        insecureEdgeTerminationPolicy = "Redirect"
      }
    }
  }

  depends_on = [helm_release.tfe]
}

output "tfe_url" {
  value = "https://${local.fqdn}"
}

output "tfe_iact_command" {
  description = "Get the initial admin creation token, then open https://<fqdn>/admin/account/new?token=<token>"
  value       = "kubectl -n ${local.tfe_namespace} exec deploy/terraform-enterprise -- tfectl admin token"
}
