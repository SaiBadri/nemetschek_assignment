# nemetschek_assignment
Objective: Create a Terraform module to provision a GCP Datastore instance database in Cloud Datastore Compatibility mode, optimized for query performance. This task assesses your proficiency with Terraform, understanding of GCP, and best practices in infrastructure as code.

# GCP Datastore Terraform Module

This Terraform module provisions a Google Cloud Datastore instance in Cloud Datastore Compatibility mode with configurable indexes and properties.

## Features

- Creates Datastore instance in specified GCP region
- Supports multiple index configurations
- Configurable kind and property definitions
- Optional composite index support
- Optional backup configuration
- Input validation for regions and index directions

## Usage

```hcl
module "datastore" {
  source = "./modules/gcp-datastore"

  project_id = "your-project-id"
  region     = "us-central1"
  name       = "my-datastore"
  kind_name  = "Users"

  index_properties = [
    {
      name = "user_index"
      properties = [
        {
          name      = "last_login"
          direction = "DESCENDING"
        },
        {
          name      = "email"
          direction = "ASCENDING"
        }
      ]
    }
  ]

  enable_composite_index = true
  enable_backup         = true
}
```

## Requirements

- Terraform >= 1.0
- Google Provider >= 4.0
- GCP Project with required APIs enabled:
  - Datastore API
  - Cloud Resource Manager API

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| project_id | GCP Project ID | string | yes |
| region | GCP region for Datastore | string | yes |
| name | Datastore instance name | string | yes |
| kind_name | Name of the Datastore kind | string | yes |
| index_properties | List of index configurations | list(object) | yes |
| enable_composite_index | Enable composite index | bool | no |
| enable_backup | Enable backup configuration | bool | no |

## Outputs

| Name | Description |
|------|-------------|
| datastore_indexes | Map of created indexes with their properties |
| datastore_instance | Details of the Datastore instance |

## Best Practices

1. Always specify explicit index configurations for optimal query performance
2. Use composite indexes only when needed for complex queries
3. Enable backup for production environments
4. Follow naming conventions for kinds and properties
