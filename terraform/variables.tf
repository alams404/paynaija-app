variable "location" {
  default = "westeurope"
}

variable "project_name" {
  default = "3tieraci"
}

variable "db_admin_username" {
  default = "pgadmin"
}

variable "db_admin_password" {
  description = "Set via TF_VAR_db_admin_password env var, not committed"
  sensitive   = true
}

variable "acr_name" {
  default = "acr3tieraciproject" # must be globally unique, lowercase, no dashes
}

variable "custom_domain" {
  description = "alams404.online"
  type        = string
}

variable "backend_image_tag" {
  default = "latest"
}

variable "frontend_image_tag" {
  default = "latest"
}
