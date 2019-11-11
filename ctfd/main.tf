resource "random_id" "ctfd" {
  byte_length = 8
}

resource "tls_private_key" "connection_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "google_compute_network" "ctfd_network" {
  name = "ctfd-network"
}

resource "google_compute_firewall" "ctfd_firewall" {
  name    = "ctfd-firewall"
  network = "${google_compute_network.ctfd_network.name}"

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }
}

resource "google_compute_address" "ctfd_ip" {
  name = "ctfd-address"
}

resource "google_compute_instance" "ctfd" {
  name         = "ctfd-${random_id.ctfd.hex}"
  machine_type = "n1-standard-1"

  boot_disk {
    initialize_params {
      image = "gce-uefi-images/ubuntu-1804-lts"
    }
  }

  network_interface {
    network = "${google_compute_network.ctfd_network.name}"
    access_config {
      nat_ip = "${google_compute_address.ctfd_ip.address}"
    }
  }

  metadata = {
    ssh-keys = "root:${tls_private_key.connection_key.public_key_openssh}"
  }
}

resource "null_resource" "ctfd" {
  connection {
    type        = "ssh"
    user        = "root"
    host        = "${google_compute_address.ctfd_ip.address}"
    private_key = "${tls_private_key.connection_key.private_key_pem}"
  }

  triggers = {
    ctf_install = join(",", [
      google_compute_instance.ctfd.name,
    filesha256("${path.module}/deploy-scripts/ctfd/install.sh")])
    ctf_install = join(",", [
      google_compute_instance.ctfd.name,
    filesha256("${path.module}/deploy-scripts/ctfd/setup.sh")])
  }

  provisioner "file" {
    source      = "${path.module}/deploy-scripts"
    destination = "/opt/"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /opt/deploy-scripts/**/*.sh",
      "/opt/deploy-scripts/ctfd/install.sh",
      "CTF_NAME='${var.ctf_name}' EMAIL='${var.email}' NAME='${var.username}' PASSWORD='${var.password}' /opt/deploy-scripts/ctfd/setup.sh"
    ]
  }
}
