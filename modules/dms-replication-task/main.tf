locals {
  enabled = module.this.enabled
}

resource "aws_dms_replication_task" "default" {
  count = local.enabled ? 1 : 0

  replication_task_id = module.this.id

  start_replication_task    = var.start_replication_task
  migration_type            = var.replication_task_migration_type
  replication_instance_arn  = var.replication_instance_arn
  source_endpoint_arn       = var.source_endpoint_arn
  target_endpoint_arn       = var.target_endpoint_arn
  table_mappings            = var.table_mappings
  replication_task_settings = var.replication_task_settings

  tags = module.this.tags
}
