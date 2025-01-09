# variables.tf
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region for Datastore instance"
  type        = string
}

variable "name" {
  description = "Name of the Datastore instance"
  type        = string
}

variable "kind_name" {
  description = "Name of the Datastore kind"
  type        = string
}

variable "index_properties" {
  description = "List of index properties for the Datastore"
  type = list(object({
    name = string
    properties = list(object({
      name      = string
      direction = string
    }))
    ancestor = optional(bool, false)
  }))
  
  validation {
    condition = alltrue([
      for idx in var.index_properties:
      alltrue([
        for prop in idx.properties:
        contains(["ASCENDING", "DESCENDING"], prop.direction)
      ])
    ])
    error_message = "Index direction must be either ASCENDING or DESCENDING."
  }
}

variable "enable_composite_index" {
  description = "Enable composite index creation"
  type        = bool
  default     = false
}

variable "enable_backup" {
  description = "Enable Datastore backup configuration"
  type        = bool
  default     = false
}
