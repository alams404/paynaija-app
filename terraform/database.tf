resource "azurerm_postgresql_flexible_server" "db" {
  name                = "psql-3tier-project"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  administrator_login    = var.db_admin_username
  administrator_password = var.db_admin_password

  sku_name   = "B_Standard_B1ms"
  version    = "15"
  storage_mb = 32768

  delegated_subnet_id = azurerm_subnet.db_subnet.id
  private_dns_zone_id = azurerm_private_dns_zone.db_dns.id

  public_network_access_enabled = false

  depends_on = [azurerm_private_dns_zone_virtual_network_link.db_dns_link]
}

resource "azurerm_postgresql_flexible_server_database" "appdb" {
  name      = "appdb"
  server_id = azurerm_postgresql_flexible_server.db.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}
