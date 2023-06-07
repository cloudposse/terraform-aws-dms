locals {
  enabled = module.this.enabled
}

resource "aws_dms_replication_instance" "default" {
  count = local.enabled ? 1 : 0

  replication_instance_id = module.this.id

  allocated_storage            = var.allocated_storage
  auto_minor_version_upgrade   = var.auto_minor_version_upgrade
  allow_major_version_upgrade  = var.allow_major_version_upgrade
  apply_immediately            = var.apply_immediately
  availability_zone            = var.availability_zone
  engine_version               = var.engine_version
  kms_key_arn                  = var.kms_key_arn
  multi_az                     = var.multi_az
  preferred_maintenance_window = var.preferred_maintenance_window
  publicly_accessible          = var.publicly_accessible
  replication_instance_class   = var.replication_instance_class
  replication_subnet_group_id  = join("", aws_dms_replication_subnet_group.default[*].id)
  vpc_security_group_ids       = var.vpc_security_group_ids

  tags = module.this.tags
}

resource "aws_dms_replication_subnet_group" "default" {
  count = local.enabled ? 1 : 0

  replication_subnet_group_id          = module.this.id
  replication_subnet_group_description = format("%s DMS replication subnet group", module.this.id)
  subnet_ids                           = var.subnet_ids

  tags = module.this.tags
}
