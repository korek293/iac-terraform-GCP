# resource "google_service_account" "sa" {
#   account_id = "${local.student_name}-${local.student_surname}-01-account"
# }

# resource "google_project_iam_binding" "storage_object_creator" {
#   project = local.project_id
#   role    = "roles/storage.objectCreator"
#   members = [
#     "serviceAccount:${google_service_account.sa.email}"
#   ]
# }

module "iam" {
  source     = "../modules/iam"
  account_id = "${local.student_name}-${local.student_surname}-01-account"
  project_id = local.project_id
  role       = "roles/storage.objectCreator"
}