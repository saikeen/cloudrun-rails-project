variable "project_id" {
  default = "iron-lodge-313910"
}
variable "sys_name" {
  default = "sample"
}
variable "env" {
  default = "prod"
}
variable "region" {
  default = "asia-northeast1"
}
variable "db_user_name" {}
variable "db_user_pass" {}
variable "db_machine_type" {
  default = "db-n1-standard-1"
}
variable "db_disk_size" {
  default = "10"
}
variable "app_memory" {
  default = "1024Mi"
}
variable "app_cpu" {
  default = "1000m"
}
