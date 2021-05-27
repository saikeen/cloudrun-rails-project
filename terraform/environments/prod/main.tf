provider "google" {
  project = var.project_id
  region  = var.region
}

terraform {
  backend "gcs" {
    bucket = "rails-cloudrun-sample-tfstate"
    prefix = "env/prod"
  }
}

module "storage" {
  source   = "../../module/storage"
  sys_name = var.sys_name
  env      = var.env
}

module "vpc" {
  source   = "../../module/vpc"
  sys_name = var.sys_name
  env = var.env
  region   = var.region
}

module "sql" {
  source          = "../../module/sql"
  project_id      = var.project_id
  sys_name        = var.sys_name
  env             = var.env
  region          = var.region
  db_user_name    = var.db_user_name
  db_user_pass    = var.db_user_pass
  db_machine_type = var.db_machine_type
  db_disk_size    = var.db_disk_size
  vpc_net_id      = module.vpc.vpc_net_id
  priv_vpc_conn   = module.vpc.priv_vpc_conn
}

module "cloudrun" {
  source        = "../../module/cloudrun"
  sys_name      = var.sys_name
  env           = var.env
  region        = var.region
  db_user_pass  = var.db_user_pass
  app_memory    = var.app_memory
  app_cpu       = var.app_cpu
  db_host       = module.sql.db_host
  db_conn_name  = module.sql.db_conn_name
  sva_conn_name = module.vpc.sva_conn_name
}

module "lb" {
  source   = "../../module/lb"
  sys_name = var.sys_name
  env      = var.env
  region   = var.region
  app_name = module.cloudrun.name
}