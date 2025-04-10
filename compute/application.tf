provider "google" {
  project = local.project_id
  region  = "us-central1"
}

data "google_compute_image" "my_image" {
  family  = "debian-12"
  project = "debian-cloud"
}

module "app_lb_resources" {
  source = "../modules/compute"

  instance_template_name_1 = "epam-tf-lab-${var.us_central1}"
  region_1                 = var.us_central1
  network1                 = data.terraform_remote_state.base.outputs.vpc_id
  subnetwork1              = data.terraform_remote_state.base.outputs.subnetworks_ids[0]
  metadata_startup_script  = file("startup.sh")
  sa_email                 = data.terraform_remote_state.base.outputs.sa_email

  instance_template_name_2 = "epam-tf-lab-${var.us_east1}"
  region_2                 = var.us_east1
  subnetwork2              = data.terraform_remote_state.base.outputs.subnetworks_ids[1]

  health_check_name = "tcp-health-check"
  health_check_port = "80"

  mig_name_1 = "epam-gcp-tf-lab-${var.us_central1}"
  mig_name_2 = "epam-gcp-tf-lab-${var.us_east1}"

  backend_name_1          = "us-central1-backend-subnet"
  backend_protocol_1      = "HTTP"
  load_balancing_scheme_1 = "EXTERNAL"

  backend_name_2          = "us-east1-backend-subnet"
  backend_protocol_2      = "HTTP"
  load_balancing_scheme_2 = "EXTERNAL"

  url_map_name = "task8-url-map"

  proxy_name = "task8-proxy"

  forwarding_rule_name      = "task8-forwarding-rule"
  forwarding_rule_protocol  = "TCP"
  forwarding_rule_lb_scheme = "EXTERNAL"
  forwarding_rule_port      = "80"
}

# resource "google_compute_region_instance_template" "instance_template_us_central1" {
#   name         = "epam-tf-lab-${var.us_central1}"
#   region       = var.us_central1
#   machine_type = "f1-micro"
#   disk {
#     source_image = "debian-cloud/debian-12"
#   }

#   tags = ["web-instances"]

#   network_interface {
#     network    = data.google_compute_network.vpc.id
#     subnetwork = data.google_compute_subnetwork.subnet_1.id
#     access_config {}
#   }

#   metadata_startup_script = file("startup.sh")

#   service_account {
#     email  = local.service_account_email
#     scopes = ["cloud-platform"]
#   }
# }

# resource "google_compute_region_instance_template" "instance_template_us_east1" {
#   name         = "epam-tf-lab-${var.us_east1}"
#   region       = var.us_east1
#   machine_type = "f1-micro"
#   disk {
#     source_image = "debian-cloud/debian-12"
#   }

#   tags = ["web-instances"]

#   network_interface {
#     network    = data.google_compute_network.vpc.id
#     subnetwork = data.google_compute_subnetwork.subnet_2.id
#     access_config {}
#   }

#   metadata_startup_script = file("startup.sh")

#   service_account {
#     email  = local.service_account_email
#     scopes = ["cloud-platform"]
#   }
# }

# resource "google_compute_health_check" "tcp_health_check" {
#   name = "tcp-health-check"
#   tcp_health_check {
#     port = "80"
#   }
# }

# resource "google_compute_region_instance_group_manager" "app-central1" {
#   name               = "epam-gcp-tf-lab-${var.us_central1}"
#   base_instance_name = "app-us-central1"
#   region             = var.us_central1


#   version {
#     instance_template = google_compute_region_instance_template.instance_template_us_central1.id
#   }

#   target_size = 1

#   named_port {
#     name = "http"
#     port = 80
#   }

#   auto_healing_policies {
#     health_check      = google_compute_health_check.tcp_health_check.id
#     initial_delay_sec = 300
#   }
# }

# resource "google_compute_region_instance_group_manager" "app-east1" {
#   name               = "epam-gcp-tf-lab-${var.us_east1}"
#   base_instance_name = "app-us-east1"
#   region             = var.us_east1

#   version {
#     instance_template = google_compute_region_instance_template.instance_template_us_east1.id
#   }

#   target_size = 1

#   named_port {
#     name = "http"
#     port = 80
#   }

#   auto_healing_policies {
#     health_check      = google_compute_health_check.tcp_health_check.id
#     initial_delay_sec = 300
#   }
# }

# resource "google_compute_backend_service" "us-central1-backend" {
#   depends_on    = [google_compute_region_instance_group_manager.app-central1]
#   name          = "us-central1-backend-subnet"
#   provider      = google
#   protocol      = "HTTP"
#   health_checks = [google_compute_health_check.tcp_health_check.id]
#   backend {
#     group = google_compute_region_instance_group_manager.app-central1.instance_group
#   }
#   load_balancing_scheme = "EXTERNAL"
# }

# resource "google_compute_backend_service" "us-east1-backend" {
#   name          = "us-east1-backend-subnet"
#   provider      = google
#   protocol      = "HTTP"
#   health_checks = [google_compute_health_check.tcp_health_check.id]
#   backend {
#     group = google_compute_region_instance_group_manager.app-east1.instance_group
#   }
#   load_balancing_scheme = "EXTERNAL"
# }

# resource "google_compute_url_map" "urlmap" {
#   name            = "task8-url-map"
#   provider        = google
#   default_service = google_compute_backend_service.us-central1-backend.id
#   host_rule {
#     hosts        = ["*"]
#     path_matcher = "mysite"
#   }
#   path_matcher {
#     name            = "mysite"
#     default_service = google_compute_backend_service.us-central1-backend.id

#     path_rule {
#       paths   = ["/east"]
#       service = google_compute_backend_service.us-east1-backend.id
#       route_action {
#         url_rewrite {
#           path_prefix_rewrite = "/"
#         }
#       }
#     }
#   }
# }

# resource "google_compute_target_http_proxy" "proxy" {
#   name    = "task8-proxy"
#   url_map = google_compute_url_map.urlmap.id
# }

# resource "google_compute_global_address" "static_ip_address" {
#   name = "my-static-address"
# }

# resource "google_compute_global_forwarding_rule" "task8_forwarding_rule" {
#   name                  = "task8-forwarding-rule"
#   provider              = google
#   ip_protocol           = "TCP"
#   load_balancing_scheme = "EXTERNAL"
#   port_range            = "80"
#   target                = google_compute_target_http_proxy.proxy.id
#   ip_address            = google_compute_global_address.static_ip_address.address
# }