terraform {
  backend "gcs" {
    bucket = "epam-gcp-tf-state-task11"
    prefix = "base"
  }
}

data "google_project" "project" {
}

data "google_compute_default_service_account" "default_sa" {
  project = data.google_project.project.project_id
}

output "project_number" {
  value = data.google_project.project.number
}

output "default_account" {
  value = data.google_compute_default_service_account.default_sa.email
}