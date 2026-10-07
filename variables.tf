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
