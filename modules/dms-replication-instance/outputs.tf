output "replication_instance_id" {
  value       = join("", aws_dms_replication_instance.default[*].replication_instance_id)
  description = "Replication instance ID"
}

output "replication_instance_arn" {
  value       = join("", aws_dms_replication_instance.default[*].replication_instance_arn)
  description = "Replication instance ARN"
}

output "subnet_group_id" {
  value       = join("", aws_dms_replication_subnet_group.default[*].replication_subnet_group_id)
  description = "Replication subnet group ID"
}
