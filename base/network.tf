provider "google" {
  project = local.project_id
  region  = "us-central1"
}

# resource "google_compute_network" "vpc_network" {
#   project                 = local.project_id
#   name                    = "${local.student_name}-${local.student_surname}-01-vpc"
#   auto_create_subnetworks = false
# }

# resource "google_compute_subnetwork" "subnetwork_central1" {
#   name          = "${local.student_name}-${local.student_surname}-01-subnetwork-central"
#   ip_cidr_range = "10.10.1.0/24"
#   region        = var.region1
#   network       = google_compute_network.vpc_network.id
# }

# resource "google_compute_subnetwork" "subnetwork_east1" {
#   name          = "${local.student_name}-${local.student_surname}-01-subnetwork-east"
#   ip_cidr_range = "10.10.3.0/24"
#   region        = var.region2
#   network       = google_compute_network.vpc_network.id
# }


# #####################
module "network" {
  source         = "../modules/network"
  net_project_id = local.project_id
  net_vpc_name   = "${local.student_name}-${local.student_surname}-01-vpc"

  net_subnet_name1 = "${local.student_name}-${local.student_surname}-01-subnetwork-central"
  net_cidr1        = "10.10.1.0/24"
  net_region1      = var.region1

  net_subnet_name2 = "${local.student_name}-${local.student_surname}-01-subnetwork-east"
  net_cidr2        = "10.10.3.0/24"
  net_region2      = var.region2
}