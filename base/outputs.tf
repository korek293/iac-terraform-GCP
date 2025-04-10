output "project_metadata_id" {
  value = google_compute_project_metadata.my_ssh_key.id
}

output "bucket_id" {
  value = google_storage_bucket.bucket1.id
}

output "vpc_id" {
  value = module.network.vpc_id
}

output "subnetworks_ids" {
  value = module.network.subnetworks_ids
}

output "sa_email" {
  value = module.iam.sa_email
}
