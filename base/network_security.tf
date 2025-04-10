# resource "google_compute_firewall" "ssh-inbound" {
#   name    = "ssh-inbound"
#   network = module.network.vpc_name

#   description = "allows ssh access from safe IP-range"

#   allow {
#     protocol = "tcp"
#     ports    = ["22"]
#   }

#   source_ranges = ["${local.my_ip}"]
#   target_tags   = ["web-instances"]
# }

# resource "google_compute_firewall" "http-inbound" {
#   name    = "http-inbound"
#   network = module.network.vpc_name

#   description = "allows http access from LoadBalancer"

#   allow {
#     protocol = "tcp"
#     ports    = ["80"]
#   }

#   source_ranges = ["130.211.0.0/22", "35.191.0.0/16", "${local.my_ip}"]
#   # source_ranges = ["0.0.0.0/0"]
#   target_tags = ["web-instances"]
# }

module "network_security_ssh" {
  source         = "../modules/network_security"
  firewall_name1 = "ssh-inbound"
  network_fire1  = module.network.vpc_name
  description    = "allows ssh access from safe IP-range"

  protocol_1 = "tcp"
  ports_1    = "22"

  source_range_1 = [local.my_ip]
  target_tags_1  = "web-instances"
}

module "network_security_http" {
  source         = "../modules/network_security"
  firewall_name1 = "http-inbound"
  network_fire1  = module.network.vpc_name
  description    = "allows http access from safe IP-range"

  protocol_1 = "tcp"
  ports_1    = "80"

  source_range_1 = ["130.211.0.0/22", "35.191.0.0/16", local.my_ip]
  target_tags_1  = "web-instances"
}