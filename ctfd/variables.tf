variable "ctf_name" {
  type = string
}

variable "email" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}

output "ip" {
  value = google_compute_address.ctfd_ip.address
}
