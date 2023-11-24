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

variable "all_vm_serial-port-enable" {
  type    = number
  default = 1
}
