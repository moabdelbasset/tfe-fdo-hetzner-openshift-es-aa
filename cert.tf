locals {
  fqdn = "${var.tfe_hostname}.${var.domain_name}"
}

resource "tls_private_key" "cert_private_key" {
  algorithm = "RSA"
}

# register
resource "acme_registration" "registration" {
  account_key_pem = tls_private_key.cert_private_key.private_key_pem
  email_address   = var.cert_email
}

# get certificate
resource "acme_certificate" "certificate" {
  account_key_pem = acme_registration.registration.account_key_pem
  common_name     = local.fqdn

  dns_challenge {
    provider = "cloudflare"

    config = {
      CLOUDFLARE_API_TOKEN     = var.cloudflare_api_token
      CLOUDFLARE_DNS_API_TOKEN = var.cloudflare_api_token
    }
  }
}

# save private key, cert and ca to files
resource "local_sensitive_file" "private_key" {
  content  = acme_certificate.certificate.private_key_pem
  filename = "${path.module}/certs/private_key.pem"
}

resource "local_file" "cert" {
  content  = acme_certificate.certificate.certificate_pem
  filename = "${path.module}/certs/cert.pem"
}

resource "local_file" "ca" {
  content  = acme_certificate.certificate.issuer_pem
  filename = "${path.module}/certs/ca.pem"
}

# TLS secret for Terraform Enterprise (cert includes the issuer chain)
resource "kubernetes_secret_v1" "tfe_tls" {
  metadata {
    name      = var.tfe_tls_secret_name
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  type = "kubernetes.io/tls"

  data = {
    "tls.crt" = "${acme_certificate.certificate.certificate_pem}${acme_certificate.certificate.issuer_pem}"
    "tls.key" = acme_certificate.certificate.private_key_pem
  }
}
