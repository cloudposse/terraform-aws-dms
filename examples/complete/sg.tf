locals {
  security_group_rules = [
    {
      type        = "ingress"
      from_port   = 0
      to_port     = 65535
      protocol    = "all"
      cidr_blocks = [local.vpc_cidr_block]
    }
  ]
}

module "security_group" {
  source  = "cloudposse/security-group/aws"
  version = "1.0.1"

  vpc_id                = local.vpc_id
  create_before_destroy = false
  allow_all_egress      = true
  rules                 = local.security_group_rules

  attributes = ["common"]
  context    = module.this.context
}
