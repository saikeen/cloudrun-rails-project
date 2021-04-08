resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "instance" {
  name                 = "${var.sys_name}-${var.env}-db-${random_id.db_name_suffix.hex}"
  database_version     = "MYSQL_8_0"
  region               = var.region
  depends_on           = [var.priv_vpc_conn]
  deletion_protection  = false
  settings {
    tier = var.db_machine_type
    disk_size = var.db_disk_size
    ip_configuration {
      ipv4_enabled    = false
      private_network = var.vpc_net_id
    }
    backup_configuration {
      enabled    = true
      location   = "asia"
      start_time = "15:00"
    }
  }
}

resource "google_sql_user" "users" {
  instance = google_sql_database_instance.instance.name
  name     = var.db_user_name
  password = var.db_user_pass
}