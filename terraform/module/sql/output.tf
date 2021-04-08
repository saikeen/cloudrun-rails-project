output "db_host" {
  value = google_sql_database_instance.instance.private_ip_address
}
output "db_conn_name" {
  value = google_sql_database_instance.instance.connection_name
}
