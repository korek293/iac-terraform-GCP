resource "google_compute_project_metadata" "my_ssh_key" {
  metadata = {
    ssh-keys = "toxic:${var.ssh_key}"
  }
}