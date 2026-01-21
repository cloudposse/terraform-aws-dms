output "replication_config_arn" {
  value       = join("", aws_dms_replication_config.default[*].arn)
  description = "DMS Serverless Replication configuration ARN"
}
