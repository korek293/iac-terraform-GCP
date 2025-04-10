resource "google_compute_project_metadata" "my_ssh_key" {
  metadata = {
    shared_ssh_key = var.ssh_key
  }
}