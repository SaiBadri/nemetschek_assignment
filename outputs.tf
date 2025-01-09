# outputs.tf
output "datastore_indexes" {
  description = "Created Datastore indexes"
  value = {
    for idx in google_datastore_index.default : idx.kind => {
      id = idx.id
      properties = idx.properties
    }
  }
}

output "datastore_instance" {
  description = "Datastore instance details"
  value = var.enable_backup ? {
    name     = google_datastore_database.default[0].database_id
    location = google_datastore_database.default[0].location
    id       = google_datastore_database.default[0].id
  } : null
}
