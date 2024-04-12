module "aurora_postgres_cluster" {
  source  = "cloudposse/rds-cluster/aws"
  version = "1.3.1"

  engine                               = "aurora-postgresql"
  engine_mode                          = "provisioned"
  engine_version                       = "15.4"
  cluster_family                       = "aurora-postgresql15"
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
  enhanced_monitoring_role_enabled     = false
  iam_database_authentication_enabled  = false
  publicly_accessible                  = false
  intra_security_group_traffic_enabled = true
  skip_final_snapshot                  = true

  cluster_parameters = [
    {
      name         = "rds.logical_replication"
      value        = "1"
      apply_method = "pending-reboot"
    },
    {
      name         = "max_replication_slots"
      value        = "10"
      apply_method = "pending-reboot"
    },
    {
      name         = "wal_sender_timeout"
      value        = "0"
      apply_method = "pending-reboot"
    },
    {
      name         = "max_worker_processes"
      value        = "8"
      apply_method = "pending-reboot"
    },
    {
      name         = "max_logical_replication_workers"
      value        = "10"
      apply_method = "pending-reboot"
    },
    {
      name         = "max_parallel_workers"
      value        = "8"
      apply_method = "pending-reboot"
    },
    {
      name         = "max_parallel_workers"
      value        = "8"
      apply_method = "pending-reboot"
    }
  ]

  context = module.this.context
}
