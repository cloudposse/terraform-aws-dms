locals {
  enabled              = module.this.enabled
  vpc_id               = module.vpc.vpc_id
  vpc_cidr_block       = module.vpc.vpc_cidr_block
  subnet_ids           = module.subnets.private_subnet_ids
  route_table_ids      = module.subnets.private_route_table_ids
  security_group_id    = module.security_group.id
  create_dms_iam_roles = local.enabled && var.create_dms_iam_roles
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
module "dms_iam" {
  source = "../../modules/dms-iam"

  enabled = local.create_dms_iam_roles

  context = module.this.context
}

module "dms_replication_instance" {
  source = "../../modules/dms-replication-instance"

  # https://docs.aws.amazon.com/dms/latest/userguide/CHAP_ReleaseNotes.html
  engine_version             = "3.5"
  replication_instance_class = "dms.t2.small"

  allocated_storage            = 50
  apply_immediately            = true
  auto_minor_version_upgrade   = true
  allow_major_version_upgrade  = false
  multi_az                     = false
  publicly_accessible          = false
  preferred_maintenance_window = "sun:10:30-sun:14:30"
  vpc_security_group_ids       = [local.security_group_id, module.aurora_postgres_cluster.security_group_id]
  subnet_ids                   = local.subnet_ids

  context = module.this.context

  depends_on = [
    # The required DMS roles must be present before replication instances can be provisioned
    module.dms_iam,
    aws_vpc_endpoint.s3
  ]
}

module "dms_endpoint_aurora_postgres" {
  source = "../../modules/dms-endpoint"

  endpoint_type                   = "source"
  engine_name                     = "aurora-postgresql"
  server_name                     = module.aurora_postgres_cluster.endpoint
  database_name                   = var.database_name
  port                            = var.database_port
  username                        = var.admin_user
  password                        = var.admin_password
  extra_connection_attributes     = ""
  secrets_manager_access_role_arn = null
  secrets_manager_arn             = null
  ssl_mode                        = "none"

  attributes = ["source"]
  context    = module.this.context

  depends_on = [
    module.aurora_postgres_cluster
  ]
}

module "dms_endpoint_s3_bucket" {
  source = "../../modules/dms-endpoint"

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
    service_access_role_arn          = join("", aws_iam_role.s3[*].arn)
  }

  extra_connection_attributes = ""

  attributes = ["target"]
  context    = module.this.context

  depends_on = [
    aws_iam_role.s3,
    module.s3_bucket
  ]
}

resource "time_sleep" "wait_for_dms_endpoints" {
  count = local.enabled ? 1 : 0

  depends_on = [
    module.dms_endpoint_aurora_postgres,
    module.dms_endpoint_s3_bucket
  ]

  create_duration  = "2m"
  destroy_duration = "30s"
}

# `dms_replication_task` will be created (at least) 2 minutes after `dms_endpoint_aurora_postgres` and `dms_endpoint_s3_bucket`
# `dms_endpoint_aurora_postgres` and `dms_endpoint_s3_bucket` will be destroyed (at least) 30 seconds after `dms_replication_task`
module "dms_replication_task" {
  source = "../../modules/dms-replication-task"

  replication_instance_arn = module.dms_replication_instance.replication_instance_arn
  start_replication_task   = true
  migration_type           = "full-load-and-cdc"
  source_endpoint_arn      = module.dms_endpoint_aurora_postgres.endpoint_arn
  target_endpoint_arn      = module.dms_endpoint_s3_bucket.endpoint_arn

  # https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TaskSettings.html
  replication_task_settings = file("${path.module}/config/replication-task-settings.json")

  # https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TableMapping.html
  table_mappings = file("${path.module}/config/replication-task-table-mappings.json")

  context = module.this.context

  depends_on = [
    module.dms_endpoint_aurora_postgres,
    module.dms_endpoint_s3_bucket,
    time_sleep.wait_for_dms_endpoints
  ]
}

# Similar to a replication task, but this provisions the DMS Serverless replication config resource.
# A replication instance is NOT needed since it's serverless.
module "dms_serverless_replication_config" {
  source = "../../modules/dms-serverless-replication-config"

  replication_type    = "full-load-and-cdc"
  source_endpoint_arn = module.dms_endpoint_aurora_postgres.endpoint_arn
  target_endpoint_arn = module.dms_endpoint_s3_bucket.endpoint_arn

  # https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TaskSettings.html
  replication_settings = file("${path.module}/config/replication-task-settings.json")
  # https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TableMapping.html
  table_mappings = file("${path.module}/config/replication-task-table-mappings.json")

  # Compute & Network Configurations
  replication_min_capacity_units = 2
  replication_max_capacity_units = 8
  vpc_security_group_ids         = [local.security_group_id, module.aurora_postgres_cluster.security_group_id]
  subnet_ids                     = local.subnet_ids

  context    = module.this.context
  attributes = ["svrless"]

  depends_on = [
    module.dms_endpoint_aurora_postgres,
    module.dms_endpoint_s3_bucket,
    time_sleep.wait_for_dms_endpoints
  ]
}


module "dms_replication_instance_event_subscription" {
  source = "../../modules/dms-event-subscription"

  event_subscription_enabled = true
  source_type                = "replication-instance"
  source_ids                 = [module.dms_replication_instance.replication_instance_id]
  sns_topic_arn              = module.sns_topic.sns_topic_arn

  # https://awscli.amazonaws.com/v2/documentation/api/latest/reference/dms/describe-event-categories.html
  event_categories = [
    "low storage",
    "configuration change",
    "maintenance",
    "deletion",
    "creation",
    "failover",
    "failure"
  ]

  attributes = ["instance"]
  context    = module.this.context
}

module "dms_replication_task_event_subscription" {
  source = "../../modules/dms-event-subscription"

  event_subscription_enabled = true
  source_type                = "replication-task"
  source_ids                 = [module.dms_replication_task.replication_task_id]
  sns_topic_arn              = module.sns_topic.sns_topic_arn

  # https://awscli.amazonaws.com/v2/documentation/api/latest/reference/dms/describe-event-categories.html
  event_categories = [
    "configuration change",
    "state change",
    "deletion",
    "creation",
    "failure"
  ]

  attributes = ["task"]
  context    = module.this.context
}
