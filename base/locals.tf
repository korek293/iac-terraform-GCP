locals {
  student_name    = "antoni"
  student_surname = "boguslawski"
  project_id      = "bahuslauski-gc-bootcamp"

  common_tags = {
    Terraform = "true"
    Project   = "epam-tf-lab"
    Owner     = "${local.student_name}_${local.student_surname}"
  }

  my_ip = "89.64.0.0/16"
}
