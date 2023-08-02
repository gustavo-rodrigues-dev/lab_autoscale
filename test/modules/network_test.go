package test

import (
	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"testing"
)

type subnet_cidr_block struct {
	cidr_block string
	az         string
	name       string
}

type tag struct {
	key   string
	value string
}

func terraformOptions(t *testing.T) *terraform.Options {
	return &terraform.Options{
		TerraformDir: "../../modules/network",
		Vars: map[string]interface{}{
			"service_name": "test",
			"aws_region":   "us-east-1",
			"vpc_cidr":     "192.168.0.0/16",
			"subnet_cidr_blocks": []map[string]interface{}{
				{
					"cidr_block": "192.168.1.0/24",
					"az":         "a",
					"name":       "test-subnet-public-a",
				},
				{
					"cidr_block": "192.168.2.0/24",
					"az":         "b",
					"name":       "test-subnet-private-b",
				},
				{
					"cidr_block": "192.168.3.0/24",
					"az":         "a",
					"name":       "test-subnet-restricted-a",
				},
			},
		},
	}
}

func TestNetwork(t *testing.T) {
	var options = terraformOptions(t)
	// Validate vpc name
	terraformOptions := terraform.WithDefaultRetryableErrors(t, options)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Validate vpc name
	awsRegion := options.Vars["aws_region"].(string)
	vpcName := terraform.Output(t, terraformOptions, "vpc_name")
	vpcId := terraform.Output(t, terraformOptions, "vpc_id")
	publicSubnetIds := terraform.OutputList(t, terraformOptions, "public_subnet_ids")
	restrictedSubnetIds := terraform.OutputList(t, terraformOptions, "restricted_subnet_ids")
	privateSubnetIds := terraform.OutputList(t, terraformOptions, "private_subnet_ids")
	subnets := aws.GetSubnetsForVpc(t, vpcId, awsRegion)

	if vpcName != options.Vars["service_name"].(string)+"-vpc" {
		t.Errorf("VPC name is not correct")
	}

	require.Equal(t, 3, len(subnets))

	// iterate publicSubnetIds
	for _, publicSubnetId := range publicSubnetIds {
		assert.True(t, aws.IsPublicSubnet(t, publicSubnetId, awsRegion))
	}

	for _, privateSubnetId := range privateSubnetIds {
		assert.False(t, aws.IsPublicSubnet(t, privateSubnetId, awsRegion))
	}

	for _, restrictedSubnetId := range restrictedSubnetIds {
		assert.False(t, aws.IsPublicSubnet(t, restrictedSubnetId, awsRegion))
	}

	// Validate subnet names
	// Validate subnet associations

}
