locals {
  enabled = module.this.enabled
}

resource "aws_dms_replication_config" "default" {
  count = local.enabled ? 1 : 0

  replication_config_identifier = module.this.id
  resource_identifier           = module.this.id
  replication_type              = var.replication_type
  source_endpoint_arn           = var.source_endpoint_arn
  target_endpoint_arn           = var.target_endpoint_arn
  replication_settings          = var.replication_settings
  table_mappings                = var.table_mappings
  start_replication             = var.start_replication

  compute_config {
    vpc_security_group_ids       = var.vpc_security_group_ids
    replication_subnet_group_id  = join("", aws_dms_replication_subnet_group.default[*].id)
    max_capacity_units           = var.replication_max_capacity_units
    min_capacity_units           = var.replication_min_capacity_units
    preferred_maintenance_window = var.replication_maintenance_window
    multi_az                     = var.multi_az
  }

  tags = module.this.tags
}

resource "aws_dms_replication_subnet_group" "default" {
  count = local.enabled ? 1 : 0

  replication_subnet_group_id          = module.this.id
  replication_subnet_group_description = format("%s DMS Serverless Replication subnet group", module.this.id)
  subnet_ids                           = var.subnet_ids

  tags = module.this.tags
}
