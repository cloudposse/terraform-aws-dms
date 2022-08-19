locals {
  security_group_id = module.vpc.vpc_default_security_group_id
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.subnets.private_subnet_ids
}

module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "1.1.0"

  ipv4_primary_cidr_block = "172.19.0.0/16"

  context = module.this.context
}

module "subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "2.0.2"

  availability_zones   = var.availability_zones
  vpc_id               = local.vpc_id
  igw_id               = [module.vpc.igw_id]
  ipv4_cidr_block      = [module.vpc.vpc_cidr_block]
  nat_gateway_enabled  = false
  nat_instance_enabled = false

  context = module.this.context
}

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
  storage_type                         = "gp2"
  allocated_storage                    = 10
  deletion_protection                  = false
  autoscaling_enabled                  = false
  storage_encrypted                    = false
  intra_security_group_traffic_enabled = false
  skip_final_snapshot                  = true
  enhanced_monitoring_role_enabled     = false
  iam_database_authentication_enabled  = false

  context = module.this.context
}

module "s3_bucket" {
  source  = "cloudposse/s3-bucket/aws"
  version = "2.0.3"

  acl                          = "private"
  versioning_enabled           = false
  force_destroy                = true
  allow_encrypted_uploads_only = true
  allow_ssl_requests_only      = true
  block_public_acls            = true
  block_public_policy          = true
  ignore_public_acls           = true
  restrict_public_buckets      = true

  context = module.this.context
}

module "sns_topic" {
  source  = "cloudposse/sns-topic/aws"
  version = "0.20.1"

  allowed_aws_services_for_sns_published = ["cloudwatch.amazonaws.com"]
  sqs_dlq_enabled                        = false
  fifo_topic                             = false
  fifo_queue_enabled                     = false

  context = module.this.context
}

module "dms_iam" {
  source = "../../modules/dms-iam"

  context = module.this.context
}
