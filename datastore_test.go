// test/datastore_test.go
package test

import (
    "testing"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
)

func TestGCPDatastoreModule(t *testing.T) {
    t.Parallel()

    // Configure Terraform options
    terraformOptions := &terraform.Options{
        TerraformDir: "../examples/basic",
        Vars: map[string]interface{}{
            "project_id": "test-project",
            "region":     "us-central1",
            "name":       "test-datastore",
            "kind_name":  "TestKind",
            "index_properties": []map[string]interface{}{
                {
                    "name": "test_index",
                    "properties": []map[string]interface{}{
                        {
                            "name":      "created_at",
                            "direction": "DESCENDING",
                        },
                    },
                },
            },
        },
    }

    // Clean up resources after test
    defer terraform.Destroy(t, terraformOptions)

    // Run Terraform Init and Apply
    terraform.InitAndApply(t, terraformOptions)

    // Verify outputs
    indexOutput := terraform.OutputMap(t, terraformOptions, "datastore_indexes")
    assert.NotNil(t, indexOutput)
    assert.Contains(t, indexOutput, "TestKind")
}

func TestGCPDatastoreInvalidRegion(t *testing.T) {
    t.Parallel()

    terraformOptions := &terraform.Options{
        TerraformDir: "../examples/basic",
        Vars: map[string]interface{}{
            "project_id": "test-project",
            "region":     "invalid-region",
            "name":       "test-datastore",
            "kind_name":  "TestKind",
            "index_properties": []map[string]interface{}{
                {
                    "name": "test_index",
                    "properties": []map[string]interface{}{
                        {
                            "name":      "created_at",
                            "direction": "DESCENDING",
                        },
                    },
                },
            },
        },
    }

    // Expect error on invalid region
    _, err := terraform.InitAndPlanE(t, terraformOptions)
    assert.Error(t, err)
}
