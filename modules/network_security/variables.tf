variable "firewall_name1" {
  default     = ""
}

variable "network_fire1" {
  default     = ""
}

variable "description" {
  default     = ""
}

variable "protocol_1" {
  default     = ""
}

variable "ports_1" {
  default     = [""]
}

variable "source_range_1" {
  type = list(string)
}

variable "target_tags_1" {
  default     = ""
}