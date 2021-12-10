terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.82.0"
    }
  }
}

variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

provider "google" {
  credentials = file("gcloud-cred.json")
  project = var.project_id
  region  = var.region
}

resource "google_container_registry" "forms-registry" {
  project  = "forms-304923"
  location = "US"
}

data "google_container_registry_image" "forms-image" {
  name = "forms-1.0"
  tag = "latest"
}

resource "google_cloud_run_service" "forms-service" {
  name     = "forms-service"
  location = "us-central1"

  template {
    spec {
      containers {
        image = data.google_container_registry_image.forms-image.image_url
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}
