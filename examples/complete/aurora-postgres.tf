module "aurora_postgres_cluster" {
  source  = "cloudposse/rds-cluster/aws"
  version = "1.3.1"

  engine                               = "aurora-postgresql"
  engine_mode                          = "provisioned"
  engine_version                       = "13.4"
  cluster_family                       = "aurora-postgresql13"
  cluster_size                         = 1
  admin_user                           = var.admin_user
  admin_password                       = var.admin_password
  db_name                              = var.database_name
  db_port                              = var.database_port
  instance_type                        = "db.t3.medium"
  vpc_id                               = local.vpc_id
  subnets                              = local.subnet_ids
  security_groups                      = [local.security_group_id]
  deletion_protection                  = false
  autoscaling_enabled                  = false
  storage_encrypted                    = false
  intra_security_group_traffic_enabled = false
  skip_final_snapshot                  = true
  enhanced_monitoring_role_enabled     = false
  iam_database_authentication_enabled  = false

  context = module.this.context
}
