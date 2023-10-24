resource "yandex_compute_instance" "vm" {
  for_each = { for key, val in var.resources_vm : key => val }
  name     = "vm-${each.value.vm_name}"

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.centos-7.image_id
      type     = "network-hdd"
      size     = each.value.disk
    }
  }

  metadata = {
    ssh-keys = "centos:${local.file_content}"
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }
  allow_stopping_for_update = true

}
