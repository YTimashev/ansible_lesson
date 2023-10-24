###ssh vars
variable "vms_ssh_root_key" {
  type        = string
  default     = "<your_ssh_ed25519_key>"
  description = "ssh-keygen -t ed25519"
}

###yandex_compute_image
variable "vm_image" {
  type        = string
  default     = "centos-7"
  description = "name web image"
}

###yandex_compute_instance_vector
variable "vm_vector_instance" {
  type        = string
  default     = "vector"
  description = "vector instance"
}

variable "vm_vector_platform" {
  type        = string
  default     = "standard-v1"
  description = "yandex platform id"
}

/*
variable "vm_web_cores" {
  type    = number
  default = 2
}

variable "vm_web_memory" {
  type    = number
  default = 1
}

variable "vm_web_core_fraction" {
  type    = number
  default = 5
}
*/

#перенесена в переменную 'metadata' как "vm_serial-port-enable"
/*
variable "vm_web_serial-port-enable" {
  type    = number
  default = 1
}
*/

variable "vm_vector_resources" {
  description = "объединение переменных блока resources"
  type        = map(number)
  default = {
    cores         = 2
    memory        = 4
    core_fraction = 20
  }
}

###yandex_compute_instance_clickhouse
variable "vm_clickhouse_instance" {
  type        = string
  default     = "clickhouse"
  description = "name clickhouse instance"
}

variable "vm_clickhouse_platform" {
  type        = string
  default     = "standard-v1"
  description = "yandex platform id"
}

/*
variable "vm_db_cores" {
  type    = number
  default = 2
}

variable "vm_db_memory" {
  type    = number
  default = 2
}

variable "vm_db_core_fraction" {
  type    = number
  default = 20
}
*/
#перенесена в переменную 'metadata' как "vm_serial-port-enable"
/*
variable "vm_db_serial-port-enable" {
  type    = number
  default = 1
}
*/

#данная конструкция не работает в блоке 'resources' файла 'main.tf'

variable "vm_clickhouse_resources" {
  description = "объединение переменных блока resources"
  type        = map(number)
  default = {
    cores         = 2
    memory        = 4
    core_fraction = 20
  }
}


#Общие переменные
variable "metadata" {
  description = "объединение переменных vm_serial-port-enable и vms_ssh_root_key"
  type        = map(any)
  default = {
    vm_serial-port-enable = 1
    vms_ssh_root_key      = "<your_ssh_ed25519_key>"
  }
}
