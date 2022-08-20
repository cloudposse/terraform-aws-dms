package test

import (
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	testStructure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
)

// Test the Terraform module in examples/workflow using Terratest.
func TestExamplesComplete(t *testing.T) {
	t.Parallel()
	randID := strings.ToLower(random.UniqueId())
	attributes := []string{randID}

	rootFolder := "../../"
	terraformFolderRelativeToRoot := "examples/complete"
	varFiles := []string{"fixtures.us-east-2.tfvars"}

	tempTestFolder := testStructure.CopyTerraformFolderToTemp(t, rootFolder, terraformFolderRelativeToRoot)

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: tempTestFolder,
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: varFiles,
		Vars: map[string]interface{}{
			"attributes": attributes,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer cleanup(t, terraformOptions, tempTestFolder)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	vpcCidr := terraform.Output(t, terraformOptions, "vpc_cidr")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "172.19.0.0/16", vpcCidr)

	// Run `terraform output` to get the value of an output variable
	privateSubnetCidrs := terraform.OutputList(t, terraformOptions, "private_subnet_cidrs")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, []string{"172.19.0.0/19", "172.19.32.0/19"}, privateSubnetCidrs)

	// Run `terraform output` to get the value of an output variable
	publicSubnetCidrs := terraform.OutputList(t, terraformOptions, "public_subnet_cidrs")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, []string{"172.19.96.0/19", "172.19.128.0/19"}, publicSubnetCidrs)

	// Run `terraform output` to get the value of an output variable
	auroraPostgresClusterIdentifier := terraform.Output(t, terraformOptions, "aurora_postgres_cluster_identifier")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-ue2-test-dms-"+randID, auroraPostgresClusterIdentifier)

	// Run `terraform output` to get the value of an output variable
	bucketId := terraform.Output(t, terraformOptions, "bucket_id")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-ue2-test-dms-"+randID, bucketId)

	// Run `terraform output` to get the value of an output variable
	dmsAuroraPostgresEndpointId := terraform.Output(t, terraformOptions, "dms_aurora_postgres_endpoint_id")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-ue2-test-dms-"+randID+"-source", dmsAuroraPostgresEndpointId)

	// Run `terraform output` to get the value of an output variable
	dmsReplicationInstanceId := terraform.Output(t, terraformOptions, "dms_replication_instance_id")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-ue2-test-dms-"+randID, dmsReplicationInstanceId)

	// Run `terraform output` to get the value of an output variable
	dmsReplicationTaskId := terraform.Output(t, terraformOptions, "dms_replication_task_id")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-ue2-test-dms-"+randID, dmsReplicationTaskId)

	// Run `terraform output` to get the value of an output variable
	dmsS3BucketEndpointId := terraform.Output(t, terraformOptions, "dms_s3_bucket_endpoint_id")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-ue2-test-dms-"+randID+"-target", dmsS3BucketEndpointId)

	// Run `terraform output` to get the value of an output variable
	snsTopicName := terraform.Output(t, terraformOptions, "sns_topic_name")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-ue2-test-dms-"+randID, snsTopicName)
}

func TestExamplesCompleteDisabled(t *testing.T) {
	t.Parallel()
	randID := strings.ToLower(random.UniqueId())
	attributes := []string{randID}

	rootFolder := "../../"
	terraformFolderRelativeToRoot := "examples/complete"
	varFiles := []string{"fixtures.us-east-2.tfvars"}

	tempTestFolder := testStructure.CopyTerraformFolderToTemp(t, rootFolder, terraformFolderRelativeToRoot)

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: tempTestFolder,
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: varFiles,
		Vars: map[string]interface{}{
			"attributes": attributes,
			"enabled":    false,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer cleanup(t, terraformOptions, tempTestFolder)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	results := terraform.InitAndApply(t, terraformOptions)

	// Should complete successfully without creating or changing any resources
	assert.Contains(t, results, "Resources: 0 added, 0 changed, 0 destroyed.")
}
