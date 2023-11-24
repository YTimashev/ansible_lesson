output "external_ip_address_jenkins-agent" {
  value       = yandex_compute_instance.platform_ja.network_interface.0.nat_ip_address
  description = "vm external ip"
}

output "external_ip_address_jenkins-master" {
  value       = yandex_compute_instance.platform_jm.network_interface.0.nat_ip_address
  description = "vm external ip"
}
