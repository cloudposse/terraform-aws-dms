output "replication_task_id" {
  value       = join("", aws_dms_replication_task.default.*.id)
  description = "Replication task ID"
}

output "replication_task_arn" {
  value       = join("", aws_dms_replication_task.default.*.replication_task_arn)
  description = "Replication task ARN"
}
