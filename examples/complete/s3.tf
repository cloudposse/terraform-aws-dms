# Upgrades to AWS DMS versions 3.4.7 and higher require that you configure AWS DMS to use VPC endpoints or use public routes.
# This requirement applies to source and target endpoints for these data stores: S3, Kinesis, Secrets Manager, DynamoDB, Amazon Redshift, and OpenSearch Service.
resource "aws_vpc_endpoint" "s3" {
  count = local.enabled ? 1 : 0

  vpc_endpoint_type = "Gateway"
  vpc_id            = local.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  route_table_ids   = local.route_table_ids

  tags = module.this.tags
}

module "s3_bucket" {
  source  = "cloudposse/s3-bucket/aws"
  version = "2.0.3"

  acl                          = "private"
  versioning_enabled           = false
  allow_encrypted_uploads_only = false
  allow_ssl_requests_only      = false
  force_destroy                = true
  block_public_acls            = true
  block_public_policy          = true
  ignore_public_acls           = true
  restrict_public_buckets      = true

  context = module.this.context
}

# https://aws.amazon.com/premiumsupport/knowledge-center/s3-bucket-dms-target/
# https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Target.S3.html
data "aws_iam_policy_document" "dms_assume_role" {
  count = local.enabled ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = [
        "dms.amazonaws.com",
        "batchoperations.s3.amazonaws.com"
      ]
      type = "Service"
    }
  }
}

data "aws_iam_policy_document" "s3" {
  count = local.enabled ? 1 : 0

  statement {
    actions = [
      "s3:PutObject",
      "s3:PutObjectTagging",
      "s3:DeleteObject",
      "s3:InitiateReplication"
    ]

    resources = [format("%s/*", module.s3_bucket.bucket_arn)]
    effect    = "Allow"
  }

  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetReplicationConfiguration",
      "s3:PutInventoryConfiguration"
    ]

    resources = [module.s3_bucket.bucket_arn]
    effect    = "Allow"
  }
}

module "s3_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  attributes = ["s3-access"]
  context    = module.this.context
}

resource "aws_iam_policy" "s3" {
  count = local.enabled ? 1 : 0

  name   = module.s3_label.id
  policy = join("", data.aws_iam_policy_document.s3.*.json)
}

resource "aws_iam_role" "s3" {
  count = local.enabled ? 1 : 0

  name               = module.s3_label.id
  assume_role_policy = join("", data.aws_iam_policy_document.dms_assume_role.*.json)
  tags               = module.s3_label.tags
}

resource "aws_iam_role_policy_attachment" "s3" {
  count = local.enabled ? 1 : 0

  policy_arn = join("", aws_iam_policy.s3.*.arn)
  role       = join("", aws_iam_role.s3.*.name)
}
