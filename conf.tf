//create instance
resource "google_compute_instance" "createbyterraform" {
  name         = "terraform"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1910"
    }
  }

  //install apache+mysql+php
  metadata_startup_script = "sudo apt update && sudo apt install apache2 mysql-server php php-mysql -y"

  network_interface {
    network = google_compute_network.default.self_link
    access_config {

    }
  }
}

//firewall https://www.terraform.io/docs/providers/google/r/compute_firewall.html

resource "google_compute_firewall" "icmp-ssh-http" {
  name    = "myfirewall"
  network = google_compute_network.default.self_link

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }
}

//network
resource "google_compute_network" "default" {
  name = "mynetwork"
}
