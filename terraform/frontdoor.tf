resource "azurerm_cdn_frontdoor_profile" "fd" {
  name                = "fd-3tier-project"
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "Standard_AzureFrontDoor"
}

resource "azurerm_cdn_frontdoor_endpoint" "fd_endpoint" {
  name                     = "${var.project_name}-endpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id
}

resource "azurerm_cdn_frontdoor_origin_group" "og" {
  name                     = "og-frontend"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id

  health_probe {
    path                = "/"
    protocol            = "Https"
    interval_in_seconds = 30
  }

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }
}

resource "azurerm_cdn_frontdoor_origin" "origin" {
  name                          = "origin-frontend-aci"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.og.id

  enabled                        = true
  host_name                      = azurerm_container_group.frontend.fqdn
  origin_host_header             = azurerm_container_group.frontend.fqdn
  certificate_name_check_enabled = true
  http_port                      = 80
  https_port                     = 443
}

resource "azurerm_cdn_frontdoor_custom_domain" "custom_domain" {
  name                     = "customdomain"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id
  host_name                = var.custom_domain

  tls {
    certificate_type = "ManagedCertificate" # Front Door-managed cert
  }
}

resource "azurerm_cdn_frontdoor_route" "route" {
  name                          = "route-frontend"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.fd_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.og.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.origin.id]
  cdn_frontdoor_custom_domain_ids = [azurerm_cdn_frontdoor_custom_domain.custom_domain.id]

  supported_protocols    = ["Http", "Https"]
  patterns_to_match       = ["/*"]
  forwarding_protocol     = "HttpOnly" # origin is plain HTTP, FD handles TLS to the client
  https_redirect_enabled  = true       # enforces HTTP -> HTTPS
  link_to_default_domain  = false
}
