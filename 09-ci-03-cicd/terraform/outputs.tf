output "external_ip_address_sonar" {
  value       = yandex_compute_instance.vm["sonar-01"].network_interface.0.nat_ip_address
  description = "vm external ip"
}

output "external_ip_address_nexus" {
  value       = yandex_compute_instance.vm["nexus-01"].network_interface.0.nat_ip_address
  description = "vm external ip"
}
