# examples/basic/main.tf
provider "google" {
  project = var.project_id
  region  = var.region
}

module "datastore" {
  source = "../../"

  project_id       = var.project_id
  region          = var.region
  name            = var.name
  kind_name       = var.kind_name
  index_properties = var.index_properties
}

# Variable definitions matching the module
variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "name" {
  type = string
}

variable "kind_name" {
  type = string
}

variable "index_properties" {
  type = list(object({
    name = string
    properties = list(object({
      name      = string
      direction = string
    }))
  }))
}

# Output all module outputs for testing
output "datastore_indexes" {
  value = module.datastore.datastore_indexes
}

output "datastore_instance" {
  value = module.datastore.datastore_instance
}
