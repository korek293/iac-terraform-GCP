resource "google_compute_region_instance_template" "instance_template_us_central1" {
  name         = var.instance_template_name_1
  region       = var.region_1
  machine_type = "f1-micro"
  disk {
    source_image = "debian-cloud/debian-12"
  }

  tags = ["web-instances"]

  network_interface {
    network    = var.network1
    subnetwork = var.subnetwork1
    access_config {}
  }

  metadata_startup_script = var.metadata_startup_script

  service_account {
    email  = var.sa_email
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_region_instance_template" "instance_template_us_east1" {
  name         = var.instance_template_name_2
  region       = var.region_2
  machine_type = "f1-micro"
  disk {
    source_image = "debian-cloud/debian-12"
  }

  tags = ["web-instances"]

  network_interface {
    network    = var.network1
    subnetwork = var.subnetwork2
    access_config {}
  }

  metadata_startup_script = var.metadata_startup_script

  service_account {
    email  = var.sa_email
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_health_check" "tcp_health_check" {
  name = var.health_check_name
  tcp_health_check {
    port = var.health_check_port
  }
}

resource "google_compute_region_instance_group_manager" "app-central1" {
  name               = var.mig_name_1
  base_instance_name = "app-us-central1"
  region             = var.region_1


  version {
    instance_template = google_compute_region_instance_template.instance_template_us_central1.id
  }

  target_size = 1

  named_port {
    name = "http"
    port = 80
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.tcp_health_check.id
    initial_delay_sec = 300
  }
}

resource "google_compute_region_instance_group_manager" "app-east1" {
  name               = var.mig_name_2
  base_instance_name = "app-us-east1"
  region             = var.region_2

  version {
    instance_template = google_compute_region_instance_template.instance_template_us_east1.id
  }

  target_size = 1

  named_port {
    name = "http"
    port = 80
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.tcp_health_check.id
    initial_delay_sec = 300
  }
}

resource "google_compute_backend_service" "us-central1-backend" {
  name          = var.backend_name_1
  provider      = google
  protocol      = var.backend_protocol_1
  health_checks = [google_compute_health_check.tcp_health_check.id]
  backend {
    group = google_compute_region_instance_group_manager.app-central1.instance_group
  }
  load_balancing_scheme = var.load_balancing_scheme_1
}

resource "google_compute_backend_service" "us-east1-backend" {
  name          = var.backend_name_2
  provider      = google
  protocol      = var.backend_protocol_2
  health_checks = [google_compute_health_check.tcp_health_check.id]
  backend {
    group = google_compute_region_instance_group_manager.app-east1.instance_group
  }
  load_balancing_scheme = var.load_balancing_scheme_2
}

resource "google_compute_url_map" "urlmap" {
  name            = var.url_map_name
  provider        = google
  default_service = google_compute_backend_service.us-central1-backend.id
  host_rule {
    hosts        = ["*"]
    path_matcher = "mysite"
  }
  path_matcher {
    name            = "mysite"
    default_service = google_compute_backend_service.us-central1-backend.id

    path_rule {
      paths   = ["/east"]
      service = google_compute_backend_service.us-east1-backend.id
      route_action {
        url_rewrite {
          path_prefix_rewrite = "/"
        }
      }
    }
  }
}

resource "google_compute_target_http_proxy" "proxy" {
  name    = var.proxy_name
  url_map = google_compute_url_map.urlmap.id
}

resource "google_compute_global_address" "static_ip_address" {
  name = "my-static-address"
}

resource "google_compute_global_forwarding_rule" "task8_forwarding_rule" {
  name                  = var.forwarding_rule_name
  provider              = google
  ip_protocol           = var.forwarding_rule_protocol
  load_balancing_scheme = var.forwarding_rule_lb_scheme
  port_range            = var.forwarding_rule_port
  target                = google_compute_target_http_proxy.proxy.id
  ip_address            = google_compute_global_address.static_ip_address.address
}