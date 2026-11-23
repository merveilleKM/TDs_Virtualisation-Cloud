# 1. Configuration du provider Google Cloud (région Belgique)
provider "google" {
  project      = "polytech-dijon"
  region       = "europe-west1" # Belgique
  access_token = "patate"
}

# 2. Création du réseau VPC (en mode personnalisé)
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
