output "vpc_cidr" {
  value       = module.vpc.vpc_cidr_block
  description = "VPC CIDR"
}

output "public_subnet_cidrs" {
  value       = module.subnets.public_subnet_cidrs
  description = "Public subnet CIDR blocks"
}

output "private_subnet_cidrs" {
  value       = module.subnets.private_subnet_cidrs
  description = "Private subnet CIDR blocks"
}

output "aurora_postgres_database_name" {
  value       = module.aurora_postgres_cluster.database_name
  description = "Aurora Postgres database name"
}

output "aurora_postgres_cluster_identifier" {
  value       = module.aurora_postgres_cluster.cluster_identifier
  description = "Aurora Postgres cluster Identifier"
}

output "aurora_postgres_cluster_arn" {
  value       = module.aurora_postgres_cluster.arn
  description = "Amazon Postgres cluster ARN"
}

output "aurora_postgres_cluster_endpoint" {
  value       = module.aurora_postgres_cluster.endpoint
  description = "Aurora Postgres cluster endpoint"
}

output "aurora_postgres_reader_endpoint" {
  value       = module.aurora_postgres_cluster.reader_endpoint
  description = "Aurora Postgres cluster reader endpoint"
}

output "bucket_id" {
  value       = module.s3_bucket.bucket_id
  description = "Bucket ID"
}

output "bucket_arn" {
  value       = module.s3_bucket.bucket_arn
  description = "Bucket ARN"
}

output "sns_topic_name" {
  value       = module.sns_topic.sns_topic_name
  description = "SNS topic name"
}

output "sns_topic_id" {
  value       = module.sns_topic.sns_topic_id
  description = "SNS topic ID"
}

output "sns_topic_arn" {
  value       = module.sns_topic.sns_topic_arn
  description = "SNS topic ARN"
}

output "dms_redshift_s3_role_arn" {
  value       = module.dms_iam.dms_redshift_s3_role_arn
  description = "DMS Redshift S3 role ARN"
}

output "dms_cloudwatch_logs_role_arn" {
  value       = module.dms_iam.dms_cloudwatch_logs_role_arn
  description = "DMS CloudWatch Logs role ARN"
}

output "dms_vpc_management_role_arn" {
  value       = module.dms_iam.dms_vpc_management_role_arn
  description = "DMS VPC management role ARN"
}

output "dms_replication_instance_id" {
  value       = module.dms_replication_instance.replication_instance_id
  description = "DMS replication instance ID"
}

output "dms_replication_instance_arn" {
  value       = module.dms_replication_instance.replication_instance_arn
  description = "DMS replication instance ARN"
}

output "dms_replication_instance_event_subscription_arn" {
  value       = module.dms_replication_instance_event_subscription.event_subscription_arn
  description = "DMS replication instance event subscription ARN"
}

output "dms_aurora_postgres_endpoint_id" {
  value       = module.dms_endpoint_aurora_postgres.endpoint_id
  description = "DMS source endpoint ID for the Aurora Postgres cluster"
}

output "dms_aurora_postgres_endpoint_arn" {
  value       = module.dms_endpoint_aurora_postgres.endpoint_arn
  description = "DMS source endpoint ARN for the Aurora Postgres cluster"
}

output "dms_s3_bucket_endpoint_id" {
  value       = module.dms_endpoint_aurora_postgres.endpoint_id
  description = "DMS target endpoint ID for the S3 bucket"
}

output "dms_s3_bucket_endpoint_arn" {
  value       = module.dms_endpoint_aurora_postgres.endpoint_arn
  description = "DMS target endpoint ARN for the S3 bucket"
}

output "dms_replication_task_id" {
  value       = module.dms_replication_task.replication_task_id
  description = "DMS replication task ID"
}

output "dms_replication_task_arn" {
  value       = module.dms_replication_task.replication_task_arn
  description = "DMS replication task ARN"
}

output "dms_replication_task_event_subscription_arn" {
  value       = module.dms_replication_task_event_subscription.event_subscription_arn
  description = "DMS replication task event subscription ARN"
}
