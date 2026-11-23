# 1. Configuration du provider Google Cloud (région Belgique)
provider "google" {
  project      = "polytech-dijon"
  region       = "europe-west1" # Belgique
  access_token = "patate"
}

# 2. Création du réseau VPC
resource "google_compute_network" "vpc_reseau" {
  name                    = "mon-reseau-vpc"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

# 3. Création d'un sous-réseau dans la région
resource "google_compute_subnetwork" "subnet_principal" {
  name          = "subnet-belgique-01"
  ip_cidr_range = "10.0.1.0/24"
  region        = "europe-west1"
  network       = google_compute_network.vpc_reseau.id
}


# 4. Autoriser le SSH via le pare-feu du VPC
resource "google_compute_firewall" "allow_ssh" {
  name    = "autoriser-ssh"
  network = google_compute_network.vpc_reseau.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh-server"] # Cible uniquement les instances avec ce tag
}

# 3. Création de l'instance Compute Engine
resource "google_compute_instance" "mon_instance" {
  name         = "mon-serveur"
  machine_type = "e2-micro"
  zone         = "subnet-belgique-01" # la même région que le sous-réseau
  tags         = ["ssh-server"]   # Applique la règle de pare-feu ci-dessus

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_reseau.id
    subnetwork = google_compute_subnetwork.subnet_principal.id

    access_config {}
  }
}
