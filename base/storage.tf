resource "random_string" "my_numbers" {
  length  = 5
  upper   = false
  special = false
}

resource "google_storage_bucket" "bucket1" {
  name          = "epam-tf-lab-${random_string.my_numbers.result}"
  location      = "US-CENTRAL1"
  force_destroy = "false"
}