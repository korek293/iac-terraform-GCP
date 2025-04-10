output "vpc_id" {
  value = google_compute_network.vpc_network.id
}

output "subnetworks_ids" {
  value = [
    google_compute_subnetwork.subnetwork_1.id,
    google_compute_subnetwork.subnetwork_2.id
  ]
}

output "vpc_name" {
  value = google_compute_network.vpc_network.name
}