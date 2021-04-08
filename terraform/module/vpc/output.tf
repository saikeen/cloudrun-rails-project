output "vpc_net_id" {
  value = google_compute_network.vpc_network.id
}
output "priv_vpc_conn" {
  value = google_service_networking_connection.private_vpc_connection
}
output "sva_conn_name" {
  value = google_vpc_access_connector.connector.name
}
