variable "openshift_config_path" {
  type = string
}

variable "openshift_config_context" {
  type = string
}

variable "namespace" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_chart_repo" {
  type = string
}

variable "db_chart_version" {
  type    = string
  default = "18.12.4"
}

variable "db_type" {
  type    = string
  default = "postgresql"
}

variable "db_username" {
  type    = string
  default = "tfe"
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_database" {
  type    = string
  default = "tfe"
}

variable "db_storage_size" {
  type    = string
  default = "8Gi"
}

variable "db_storage_class" {
  type    = string
  default = "lvms-vg1"
}

variable "redis_name" {
  type    = string
  default = "tfe-redis"
}

variable "redis_chart_repo" {
  type    = string
  default = "https://charts.bitnami.com/bitnami"
}

variable "redis_chart_version" {
  type    = string
  default = "28.3.1"
}

variable "redis_password" {
  type      = string
  sensitive = true
}

variable "redis_storage_class" {
  type    = string
  default = "lvms-vg1"
}

variable "redis_storage_size" {
  type    = string
  default = "8Gi"
}

variable "redis_type" {
  type    = string
  default = "redis"
}

variable "minio_name" {
  type    = string
  default = "tfe-minio"
}

variable "minio_chart_repo" {
  type    = string
  default = "https://charts.bitnami.com/bitnami"
}

variable "minio_type" {
  type    = string
  default = "minio"
}

variable "minio_chart_version" {
  type    = string
  default = "17.0.21"
}

variable "minio_root_user" {
  type    = string
  default = "admin"
}

variable "minio_root_password" {
  type      = string
  sensitive = true
}

variable "minio_bucket" {
  type    = string
  default = "tfe"
}

variable "minio_storage_class" {
  type    = string
  default = "lvms-vg1"
}

variable "minio_storage_size" {
  type    = string
  default = "20Gi"
}

variable "minio_image_repo" {
  type    = string
  default = "bitnamilegacy/minio"
}

variable "minio_console_image_repo" {
  type    = string
  default = "bitnamilegacy/minio-object-browser"
}

variable "acme_server_url" {
  type = string
}
variable "cert_email" {
  type = string
}

variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "tfe_hostname" {
  type    = string
  default = "tfe"
}

variable "domain_name" {
  type = string
}

variable "tfe_tls_secret_name" {
  type    = string
  default = "tfe-certs"
}

variable "cloudflare_account_id" {
  type = string
}

variable "cloudflare_tunnel_name" {
  type = string
}

variable "openshift_ingress_ip" {
  type = string
}

variable "cloudflare_tunnel_existing_ingress" {
  type = list(object({
    hostname      = string
    service       = string
    no_tls_verify = optional(bool, false)
  }))
  default = []
}

variable "tfe_name" {
  type    = string
  default = "terraform-enterprise"
}

variable "tfe_chart_repo" {
  type    = string
  default = "https://helm.releases.hashicorp.com"
}

variable "tfe_type" {
  type    = string
  default = "terraform-enterprise"
}

variable "tfe_chart_version" {
  type    = string
  default = "2.0.8"
}

variable "tfe_release" {
  description = "Terraform Enterprise image tag"
  type        = string
}

variable "registry_images_url" {
  type    = string
  default = "images.releases.hashicorp.com"
}

variable "tfe_image_pull_secret_name" {
  type    = string
  default = "terraform-enterprise"
}

variable "tfe_license" {
  type      = string
  sensitive = true
}

variable "tfe_encryption_password" {
  type      = string
  sensitive = true
}

variable "tfe_replica_count" {
  type    = number
  default = 1
}

variable "helm_timeout" {
  description = "Seconds to wait for the TFE release; first start runs DB migrations"
  type        = number
  default     = 900
}
