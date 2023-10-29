###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

###yandex_compute_image
variable "centos" {
  type        = string
  default     = "centos-7"
  description = "name web image"
}

variable "ubuntu" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "name web image"
}

variable "all_vm_platform" {
  type        = string
  default     = "standard-v1"
  description = "yandex platform id"
}

variable "all_vm_resources" {
  description = "объединение переменных блока resources"
  type        = map(number)
  default = {
    cores         = 2
    memory        = 4
    core_fraction = 20
  }
}

###yandex_compute_instance
variable "vm_vector_instance" {
  type        = string
  default     = "vector"
  description = "vector instance"
}

variable "vm_clickhouse_instance" {
  type        = string
  default     = "clickhouse"
  description = "name clickhouse instance"
}

variable "vm_lighthouse_instance" {
  type        = string
  default     = "vector"
  description = "vector instance"
}

variable "all_vm_serial-port-enable" {
  type    = number
  default = 1
}

/*
###ssh vars
variable "vms_ssh_root_key" {
  type        = string
  default     = "<your_ssh_ed25519_key>"
  description = "ssh-keygen -t ed25519"
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
*/
