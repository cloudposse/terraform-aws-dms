locals {
  enabled   = module.this.enabled
  partition = join("", data.aws_partition.current.*.partition)
}

data "aws_partition" "current" {
  count = local.enabled ? 1 : 0
}

data "aws_iam_policy_document" "dms_assume_role" {
  count = local.enabled ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["dms.amazonaws.com"]
      type        = "Service"
    }
  }
}

# Database Migration Service requires
# the below IAM Roles to be created before
# replication instances can be created.
# The roles should be provisioned only once per account.
# https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Security.html
# https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Security.html#CHAP_Security.APIRole
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_replication_instance
#  * dms-vpc-role
#  * dms-cloudwatch-logs-role
#  * dms-access-for-endpoint

resource "aws_iam_role" "dms_redshift_s3" {
  count = local.enabled ? 1 : 0

  assume_role_policy = join("", data.aws_iam_policy_document.dms_assume_role.*.json)
  name               = "dms-access-for-endpoint"

  tags = module.this.tags
}

resource "aws_iam_role_policy_attachment" "dms_redshift_s3" {
  count = local.enabled ? 1 : 0

  policy_arn = "arn:${local.partition}:iam::aws:policy/service-role/AmazonDMSRedshiftS3Role"
  role       = join("", aws_iam_role.dms_redshift_s3.*.name)
}

resource "aws_iam_role" "dms_cloudwatch_logs" {
  count = local.enabled ? 1 : 0

  assume_role_policy = join("", data.aws_iam_policy_document.dms_assume_role.*.json)
  name               = "dms-cloudwatch-logs-role"

  tags = module.this.tags
}

resource "aws_iam_role_policy_attachment" "dms_cloudwatch_logs" {
  count = local.enabled ? 1 : 0

  policy_arn = "arn:${local.partition}:iam::aws:policy/service-role/AmazonDMSCloudWatchLogsRole"
  role       = join("", aws_iam_role.dms_cloudwatch_logs.*.name)
}

resource "aws_iam_role" "dms_vpc_management" {
  count = local.enabled ? 1 : 0

  assume_role_policy = join("", data.aws_iam_policy_document.dms_assume_role.*.json)
  name               = "dms-vpc-role"

  tags = module.this.tags
}

resource "aws_iam_role_policy_attachment" "amazon_dms_vpc_management" {
  count = local.enabled ? 1 : 0

  policy_arn = "arn:${local.partition}:iam::aws:policy/service-role/AmazonDMSVPCManagementRole"
  role       = join("", aws_iam_role.dms_vpc_management.*.name)
}
