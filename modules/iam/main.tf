resource "google_service_account" "sa" {
  account_id = var.account_id
}

resource "google_project_iam_binding" "storage_object_creator" {
  project = var.project_id
  role    = var.role
  members = [
    "serviceAccount:${google_service_account.sa.email}"
  ]
}