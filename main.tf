provider "google" {
  credentials = "${file("credentials/gcloud.json")}"
  project     = "${jsondecode(file("credentials/gcloud.json"))["project_id"]}"
  region      = "europe-west2"
  zone        = "europe-west2-a"
}

module "ctf" {
  source = "./ctfd"

  ctf_name = "test"
  email    = "admin@none"
  username = "admin"
  password = "adminpass"
}
