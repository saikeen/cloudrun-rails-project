resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
  name          = "${var.sys_name}-${var.env}-private-subnet"
  ip_cidr_range = "10.1.0.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_network" "vpc_network" {
  name = "${var.sys_name}-${var.env}-vpc-net"
  auto_create_subnetworks = false
}

resource "google_compute_global_address" "private_ip_address" {
  name          = "${var.sys_name}-${var.env}-ga"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc_network.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network = google_compute_network.vpc_network.id
  service = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_vpc_access_connector" "connector" {
  name          = "data-access-vpc-connector"
  ip_cidr_range = "10.8.0.0/28"
  network       = google_compute_network.vpc_network.name
  region        = var.region
}
