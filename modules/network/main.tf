resource "google_compute_network" "vpc_network" {
  project                 = var.net_project_id
  name                    = var.net_vpc_name
  auto_create_subnetworks = var.net_auto_creation_subnetwork
}

resource "google_compute_subnetwork" "subnetwork_1" {
  name          = var.net_subnet_name1
  ip_cidr_range = var.net_cidr1
  region        = var.net_region1
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "subnetwork_2" {
  name          = var.net_subnet_name2
  ip_cidr_range = var.net_cidr2
  region        = var.net_region2
  network       = google_compute_network.vpc_network.id
}