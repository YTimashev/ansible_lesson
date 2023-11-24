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
  family = var.centos
}

#vm
resource "yandex_compute_instance" "vm" {
  for_each    = local.vm_nodes
  name        = each.key
  description = "Node for ${each.key}"
  platform_id = var.all_vm_platform

  resources {
    cores         = var.all_vm_resources["cores"]
    memory        = var.all_vm_resources["memory"]
    core_fraction = var.all_vm_resources.core_fraction
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

  #metadata = var.metadata
  metadata = {
    serial-port-enable = var.all_vm_serial-port-enable
    ssh-keys           = "centos:${file("~/.ssh/id_ed25519.pub")}"
    #    ssh-keys           = var.vms_ssh_root_key
  }

}
