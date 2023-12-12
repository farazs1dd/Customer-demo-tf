# Print Azure Instance Public
output "azurerm_public_ip" {
  value = azurerm_public_ip.publicip.ip_address
}
