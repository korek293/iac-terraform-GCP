# data "terraform_remote_state" "state_local" {
#   backend = "local"

#   config = {
#     path = "../base/terraform.tfstate"
#   }
# }

data "terraform_remote_state" "base" {
  backend = "gcs"
  config = {
    bucket = "epam-gcp-tf-state-task11"
    prefix = "base"
  }
}

terraform {
  backend "gcs" {
    bucket = "epam-gcp-tf-state-task11"
    prefix = "compute"
  }
}

output "network_id" {
  value = data.terraform_remote_state.base.outputs.vpc_id
}

output "subnetworks_ids" {
  value = data.terraform_remote_state.base.outputs.subnetworks_ids
}

output "sa_email" {
  value = data.terraform_remote_state.base.outputs.sa_email
}




# data "google_project" "project" {
# }

# data "google_compute_network" "vpc" {
#   name = "${local.student_name}-${local.student_surname}-01-vpc"
# }

# data "google_compute_subnetwork" "subnet_1" {
#   name   = "${local.student_name}-${local.student_surname}-01-subnetwork-central"
#   region = var.us_central1
# }

# data "google_compute_subnetwork" "subnet_2" {
#   name   = "${local.student_name}-${local.student_surname}-01-subnetwork-east"
#   region = var.us_east1
# }

# data "google_storage_bucket" "my_bucket" {
#   name = "epam-tf-lab-xn_8e"
# }

# output "vpc_id" {
#   value = data.google_compute_network.vpc.id
# }

# output "subnetworks_ids" {
#   value = [
#     data.google_compute_subnetwork.subnet_1.id,
#     data.google_compute_subnetwork.subnet_2.id
#   ]
# }

# output "project_metadata_id" {
#   value = data.google_project.project.project_id
# }

# output "bucket_id" {
#   value = data.google_storage_bucket.my_bucket.id
# }

# resource "google_service_account" "test-import" {
#   account_id = "test-import"
# }