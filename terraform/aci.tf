# Frontend — public, no VNet integration (Front Door needs a reachable origin)
resource "azurerm_container_group" "frontend" {
  name                = "aci-frontend"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  ip_address_type     = "Public"
  dns_name_label      = "${var.project_name}-frontend"

  image_registry_credential {
    server   = azurerm_container_registry.acr.login_server
    username = azurerm_container_registry.acr.admin_username
    password = azurerm_container_registry.acr.admin_password
  }

  container {
    name   = "frontend"
    image  = "${azurerm_container_registry.acr.login_server}/frontend:${var.frontend_image_tag}"
    cpu    = "0.5"
    memory = "1.0"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}

# Backend — VNet-joined, no public IP
resource "azurerm_container_group" "backend" {
  name                = "aci-backend"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  ip_address_type     = "Private"
  subnet_ids          = [azurerm_subnet.backend_subnet.id]

  image_registry_credential {
    server   = azurerm_container_registry.acr.login_server
    username = azurerm_container_registry.acr.admin_username
    password = azurerm_container_registry.acr.admin_password
  }

  container {
    name   = "backend"
    image  = "${azurerm_container_registry.acr.login_server}/backend:${var.backend_image_tag}"
    cpu    = "0.5"
    memory = "1.0"

    ports {
      port     = 8080
      protocol = "TCP"
    }

    environment_variables = {
      DB_HOST = azurerm_postgresql_flexible_server.db.fqdn
      DB_NAME = azurerm_postgresql_flexible_server_database.appdb.name
      DB_USER = var.db_admin_username
    }

    secure_environment_variables = {
      DB_PASSWORD = var.db_admin_password
    }
  }
}
