# Fetch the Cloudflare zone information
data "cloudflare_zone" "main" {
  filter = {
    name = var.domain_name
  }
}

# Existing tunnel running on the Proxmox host (vmbr1)
data "cloudflare_zero_trust_tunnel_cloudflared" "existing" {
  account_id = var.cloudflare_account_id
  filter = {
    name       = var.cloudflare_tunnel_name
    is_deleted = false
  }
}

locals {
  # Let's Encrypt staging certs aren't publicly trusted, so cloudflared can't verify them
  acme_staging = strcontains(var.acme_server_url, "staging")
}

# Ingress rules of the existing tunnel.
# This replaces the whole rule list, so existing rules must be kept in var.cloudflare_tunnel_existing_ingress.
resource "cloudflare_zero_trust_tunnel_cloudflared_config" "existing" {
  account_id = var.cloudflare_account_id
  tunnel_id  = data.cloudflare_zero_trust_tunnel_cloudflared.existing.id

  config = {
    ingress = concat(
      [
        for rule in var.cloudflare_tunnel_existing_ingress : {
          hostname = rule.hostname
          service  = rule.service
          origin_request = {
            no_tls_verify = rule.no_tls_verify
          }
        }
      ],
      [
        # TFE through the OpenShift router (passthrough Route), SNI = TFE hostname
        {
          hostname = local.fqdn
          service  = "https://${var.openshift_ingress_ip}:443"
          origin_request = {
            origin_server_name = local.fqdn
            no_tls_verify      = local.acme_staging
          }
        },
        {
          service = "http_status:404"
        }
      ]
    )
  }
}

# Create the DNS record pointing to the tunnel
resource "cloudflare_dns_record" "tfe" {
  zone_id = data.cloudflare_zone.main.zone_id
  name    = local.fqdn
  type    = "CNAME"
  content = "${data.cloudflare_zero_trust_tunnel_cloudflared.existing.id}.cfargotunnel.com"
  ttl     = 1
  proxied = true
}
