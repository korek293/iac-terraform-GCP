variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "availability_zones" {
  type    = list(string)
  default = ["a", "b", "c"]
}

variable "student_name" {
  default = "John_Doe"
}
