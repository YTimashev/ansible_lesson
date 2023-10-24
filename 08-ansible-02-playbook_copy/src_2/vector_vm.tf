
#Создаем ВМ
resource "yandex_compute_instance" "vector-01" {
  name        = "vector-01"
  platform_id = "standard-v1"

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 20
  }


  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.centos-7.image_id
      type     = "network-hdd"
      size     = 5
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
