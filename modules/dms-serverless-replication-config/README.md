# dms-serverless-replication-config

Terraform module to provision DMS Serverless Replication configuration resource. Because this is serverless, a DMS replication instance is **NOT** needed at all.

## Usage

```hcl
module "dms_iam" {
  source = "cloudposse/dms/aws//modules/dms-iam"
  # Cloud Posse recommends pinning every module to a specific version
  # version     = "x.x.x"

  context = module.this.context
}

module "vpc" {
  source = "cloudposse/vpc/aws"
  # Cloud Posse recommends pinning every module to a specific version
  # version     = "x.x.x"

  ipv4_primary_cidr_block = "172.19.0.0/16"

  context = module.this.context
}

module "subnets" {
  source = "cloudposse/dynamic-subnets/aws"
  # Cloud Posse recommends pinning every module to a specific version
  # version     = "x.x.x"

  availability_zones   = ["us-east-2a", "us-east-2b"]
  vpc_id               = local.vpc_id
  igw_id               = [module.vpc.igw_id]
  ipv4_cidr_block      = [module.vpc.vpc_cidr_block]
  nat_gateway_enabled  = false
  nat_instance_enabled = false

  context = module.this.context
}

module "aurora_postgres_cluster" {
  source = "cloudposse/rds-cluster/aws"
  # Cloud Posse recommends pinning every module to a specific version
  # version     = "x.x.x"

  engine                               = "aurora-postgresql"
  engine_mode                          = "provisioned"
  engine_version                       = "13.4"
  cluster_family                       = "aurora-postgresql13"
  cluster_size                         = 1
  admin_user                           = "admin_user"
  admin_password                       = "admin_password"
  db_name                              = "postgres"
  db_port                              = 5432
  instance_type                        = "db.t3.medium"
  vpc_id                               = module.vpc.vpc_id
  subnets                              = module.subnets.private_subnet_ids
  security_groups                      = [module.vpc.vpc_default_security_group_id]
  deletion_protection                  = false
  autoscaling_enabled                  = false
  storage_encrypted                    = false
  intra_security_group_traffic_enabled = false
  skip_final_snapshot                  = true
  enhanced_monitoring_role_enabled     = false
  iam_database_authentication_enabled  = false

  cluster_parameters = [
    {
      name         = "rds.logical_replication"
      value        = "1"
      apply_method = "pending-reboot"
    },
    {
      name         = "max_replication_slots"
      value        = "10"
      apply_method = "pending-reboot"
    },
    {
      name         = "wal_sender_timeout"
      value        = "0"
      apply_method = "pending-reboot"
    },
    {
      name         = "max_worker_processes"
      value        = "8"
      apply_method = "pending-reboot"
    },
    {
      name         = "max_logical_replication_workers"
      value        = "10"
      apply_method = "pending-reboot"
    },
    {
      name         = "max_parallel_workers"
      value        = "8"
      apply_method = "pending-reboot"
    },
    {
      name         = "max_parallel_workers"
      value        = "8"
      apply_method = "pending-reboot"
    }
  ]

  context = module.this.context
}

module "dms_endpoint_aurora_postgres" {
  source = "cloudposse/dms/aws//modules/dms-endpoint"
  # Cloud Posse recommends pinning every module to a specific version
  # version     = "x.x.x"

  endpoint_type                   = "source"
  engine_name                     = "aurora-postgresql"
  server_name                     = module.aurora_postgres_cluster.reader_endpoint
  database_name                   = "postgres"
  port                            = 5432
  username                        = "admin_user"
  password                        = "admin_password"
  extra_connection_attributes     = ""
  secrets_manager_access_role_arn = null
  secrets_manager_arn             = null
  ssl_mode                        = "none"

  attributes = ["source"]
  context    = module.this.context
}

# Upgrades to AWS DMS versions 3.4.7 and higher require that you configure AWS DMS to use VPC endpoints or use public routes.
# This requirement applies to source and target endpoints for these data stores: S3, Kinesis, Secrets Manager, DynamoDB, Amazon Redshift, and OpenSearch Service.
resource "aws_vpc_endpoint" "s3" {
  vpc_endpoint_type = "Gateway"
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  route_table_ids   = module.subnets.private_route_table_ids

  tags = module.this.tags
}

module "s3_bucket" {
  source = "cloudposse/s3-bucket/aws"
  # Cloud Posse recommends pinning every module to a specific version
  # version     = "x.x.x"

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

module "dms_endpoint_s3_bucket" {
  source = "cloudposse/dms/aws//modules/dms-endpoint"
  # Cloud Posse recommends pinning every module to a specific version
  # version     = "x.x.x"

  endpoint_type = "target"
  engine_name   = "s3"

  s3_settings = {
    bucket_name                      = module.s3_bucket.bucket_id
    bucket_folder                    = null
    cdc_inserts_only                 = false
    csv_row_delimiter                = " "
    csv_delimiter                    = ","
    data_format                      = "parquet"
    compression_type                 = "GZIP"
    date_partition_delimiter         = "NONE"
    date_partition_enabled           = true
    date_partition_sequence          = "YYYYMMDD"
    include_op_for_full_load         = true
    parquet_timestamp_in_millisecond = true
    timestamp_column_name            = "timestamp"
    service_access_role_arn          = aws_iam_role.s3.arn
  }

  extra_connection_attributes = ""

  attributes = ["target"]
  context    = module.this.context
}

module "dms_serverless_replicationconfig" {
  source = "cloudposse/dms/aws//modules/dms-serverless-replication-config"
  # Cloud Posse recommends pinning every module to a specific version
  # version     = "x.x.x"

  replication_type = "full-load-and-cdc"
  source_endpoint_arn = module.dms_endpoint_aurora_postgres.endpoint_arn
  target_endpoint_arn = module.dms_endpoint_s3_bucket.endpoint_arn

  # https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TaskSettings.html
  replication_settings = file("${path.module}/config/replication-task-settings.json")
  # https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TableMapping.html
  table_mappings = file("${path.module}/config/replication-task-table-mappings.json")

  # Compute & Network Configurations
  replication_min_capacity_units = 2
  replication_max_capacity_units = 8
  vpc_security_group_ids = []
  subnet_ids = []

  context = module.this.context
  attributes = ["serverless"]
}
```

## Notes

[AWS DMS Serverless](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Serverless.html)
The initial resource creation may take >20 minutes, especially if the `start_replication` variable is set to true, in which case the replication will start upon creation. Check out this diagram to see the definition of each status in the lifecycle: [AWS DMS Serverless Components](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Serverless.Components.html)
