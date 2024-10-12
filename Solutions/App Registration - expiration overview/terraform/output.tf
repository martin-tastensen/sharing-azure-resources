output "AzureManagedDomain" {
  value = azurerm_email_communication_service_domain.AzureManagedDomain.from_sender_domain
}

output "required_dns_records" {
  value = azurerm_email_communication_service_domain.AzureManagedDomain.verification_records
}