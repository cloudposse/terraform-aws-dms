module "s3_bucket" {
  source  = "cloudposse/s3-bucket/aws"
  version = "2.0.3"

  acl                          = "private"
  versioning_enabled           = false
  force_destroy                = true
  allow_encrypted_uploads_only = true
  allow_ssl_requests_only      = true
  block_public_acls            = true
  block_public_policy          = true
  ignore_public_acls           = true
  restrict_public_buckets      = true

  context = module.this.context
}

# https://aws.amazon.com/premiumsupport/knowledge-center/s3-bucket-dms-target/
# https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Target.S3.html
data "aws_iam_policy_document" "dms_assume_role" {
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

resource "aws_iam_policy" "s3" {
  name   = module.this.id
  policy = data.aws_iam_policy_document.s3.json
}

resource "aws_iam_role" "s3" {
  name               = module.this.id
  assume_role_policy = data.aws_iam_policy_document.dms_assume_role.json
  tags               = module.this.tags
}

resource "aws_iam_role_policy_attachment" "s3" {
  policy_arn = aws_iam_policy.s3.arn
  role       = aws_iam_role.s3.name
}
