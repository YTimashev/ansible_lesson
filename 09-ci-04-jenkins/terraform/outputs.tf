output "external_ip_address_jenkins-master-01" {
  value       = yandex_compute_instance.vm["jenkins-master-01"].network_interface.0.nat_ip_address
  description = "vm external ip"
}

output "external_ip_address_jenkins-agent-01" {
  value       = yandex_compute_instance.vm["jenkins-agent-01"].network_interface.0.nat_ip_address
  description = "vm external ip"
}
