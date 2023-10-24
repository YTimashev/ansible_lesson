resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

data "yandex_compute_image" "centos-7" {
  family = var.vm_image
}

#vm_web
resource "yandex_compute_instance" "platform" {
  name        = local.vm_vector
  platform_id = var.vm_vector_platform

  resources {
    cores         = var.vm_vector_resources["cores"]
    memory        = var.vm_vector_resources["memory"]
    core_fraction = var.vm_vector_resources.core_fraction
  }

  /*
  resources {
    cores         = var.vm_web_cores
    memory        = var.vm_web_memory
    core_fraction = var.vm_web_core_fraction
  }
  */

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.centos-7.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = var.metadata

  /*
  metadata = {
    serial-port-enable = var.vm_web_serial-port-enable
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
  */

}

#vm_db
resource "yandex_compute_instance" "platform2" {
  name        = local.vm_clickhouse
  platform_id = var.vm_clickhouse_platform

  resources {
    cores         = var.vm_clickhouse_resources["cores"]
    memory        = var.vm_clickhouse_resources["memory"]
    core_fraction = var.vm_clickhouse_resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.centos-7.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = var.metadata

  /*
  metadata = {
    serial-port-enable = var.vm_db_serial-port-enable
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
  */
}
