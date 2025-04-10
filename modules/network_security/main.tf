resource "google_compute_firewall" "ssh-inbound" {
  name    = var.firewall_name1
  network = var.network_fire1

  description = var.description

  allow {
    protocol = var.protocol_1
    ports    = [var.ports_1]
  }

  source_ranges = var.source_range_1
  target_tags   = [var.target_tags_1]
}