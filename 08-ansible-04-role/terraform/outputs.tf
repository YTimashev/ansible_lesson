output "external_ip_address_vector" {
  value       = yandex_compute_instance.platform_v.network_interface.0.nat_ip_address
  description = "vm external ip"
}

output "external_ip_address_clickhouse" {
  value       = yandex_compute_instance.platform_ch.network_interface.0.nat_ip_address
  description = "vm external ip"
}

output "external_ip_address_lighthouse" {
  value       = yandex_compute_instance.platform_lh.network_interface.0.nat_ip_address
  description = "vm external ip"
}
