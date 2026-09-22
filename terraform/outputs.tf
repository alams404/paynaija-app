output "frontdoor_endpoint_hostname" {
  value       = azurerm_cdn_frontdoor_endpoint.fd_endpoint.host_name
  description = "Point your custom domain's CNAME record here"
}

output "custom_domain_validation_token" {
  value       = azurerm_cdn_frontdoor_custom_domain.custom_domain.validation_token
  description = "Add this as a TXT record at _dnsauth.<your-subdomain> to validate the domain"
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "backend_private_ip" {
  value = azurerm_container_group.backend.ip_address
}

output "postgres_fqdn" {
  value = azurerm_postgresql_flexible_server.db.fqdn
}
