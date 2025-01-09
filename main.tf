# main.tf
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0.0"
    }
  }
}

# Input variable validation
locals {
  valid_regions = [
    "us-central1",
    "europe-west1",
    "asia-east1"
    # Add more valid regions as needed
  ]

  # Validate region
  validate_region = (
    contains(local.valid_regions, var.region) 
    ? null 
    : file("ERROR: Invalid region specified")
  )
}

# Datastore instance creation
resource "google_datastore_index" "default" {
  for_each = { for idx in var.index_properties : idx.name => idx }

  kind = var.kind_name
  ancestor = lookup(each.value, "ancestor", false)

  dynamic "properties" {
    for_each = each.value.properties
    content {
      name = properties.value.name
      direction = properties.value.direction
    }
  }

  project = var.project_id
}

# Optional Composite Index configuration
resource "google_datastore_index" "composite" {
  count = var.enable_composite_index ? 1 : 0

  kind = var.kind_name
  ancestor = false

  properties {
    name = "created_at"
    direction = "DESCENDING"
  }
  properties {
    name = "priority"
    direction = "ASCENDING"
  }

  project = var.project_id
}

# Datastore backup configuration (optional)
resource "google_datastore_database" "default" {
  count    = var.enable_backup ? 1 : 0
  project  = var.project_id
  location = var.region
  database_id = var.name

  depends_on = [
    google_datastore_index.default
  ]
}
