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

output "database_name" {
  value       = module.aurora_postgres_cluster.database_name
  description = "Database name"
}

output "cluster_identifier" {
  value       = module.aurora_postgres_cluster.cluster_identifier
  description = "Aurora cluster Identifier"
}

output "cluster_arn" {
  value       = module.aurora_postgres_cluster.arn
  description = "Amazon Resource Name (ARN) of the Aurora cluster"
}

output "cluster_endpoint" {
  value       = module.aurora_postgres_cluster.endpoint
  description = "Aurora cluster endpoint"
}

output "reader_endpoint" {
  value       = module.aurora_postgres_cluster.reader_endpoint
  description = "Aurora cluster reader endpoint"
}

output "bucket_id" {
  value       = module.s3_bucket.bucket_id
  description = "Bucket ID"
}

output "bucket_arn" {
  value       = module.s3_bucket.bucket_arn
  description = "Bucket ARN"
}
