variable "start_replication" {
  type        = bool
  description = "If set to `true`, the created replication will be started automatically"
  default     = true
}

variable "replication_type" {
  type        = string
  description = "The replication type for the migration. Can be one of `full-load`, `cdc`, `full-load-and-cdc`"
  default     = "full-load-and-cdc"
}

variable "source_endpoint_arn" {
  type        = string
  description = "The Amazon Resource Name (ARN) string that uniquely identifies the source endpoint"
}

variable "target_endpoint_arn" {
  type        = string
  description = "The Amazon Resource Name (ARN) string that uniquely identifies the target endpoint"
}

variable "table_mappings" {
  type        = string
  description = "An escaped JSON string that contains the table mappings. See https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TableMapping.html for more details"
}

variable "replication_settings" {
  type        = string
  description = "An escaped JSON string that contains the task settings. See https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TaskSettings.html for more details"
  default     = null
}

variable "replication_max_capacity_units" {
  type        = string
  description = <<EOT
  Specifies the maximum value of the DMS capacity units (DCUs) for which a given DMS Serverless replication can be provisioned.
  A single DCU is 2GB of RAM, with 2 DCUs as the minimum value allowed.
  The list of valid DCU values includes 2, 4, 8, 16, 32, 64, 128, 192, 256, and 384.
  EOT
  default     = "16"

  validation {
    condition     = can(regex("^(2|4|8|16|32|64|128|192|256|384)$", var.replication_max_capacity_units))
    error_message = "Invalid replication_max_capacity_units. Must be one of 2, 4, 8, 16, 32, 64, 128, 192, 256, 384."
  }
}

variable "replication_min_capacity_units" {
  type        = string
  description = <<EOT
  Specifies the minimum value of the DMS capacity units (DCUs) for which a given DMS Serverless replication can be provisioned.
  The list of valid DCU values includes 2, 4, 8, 16, 32, 64, 128, 192, 256, and 384.
  If this value isn't set DMS scans the current activity of available source tables to identify an optimum setting for this parameter.
  EOT
  default     = "2"

  validation {
    condition     = can(regex("^(2|4|8|16|32|64|128|192|256|384)$", var.replication_min_capacity_units))
    error_message = "Invalid replication_min_capacity_units. Must be one of 2, 4, 8, 16, 32, 64, 128, 192, 256, 384."
  }
}

variable "replication_maintenance_window" {
  type        = string
  description = <<EOT
  The weekly time range during which system maintenance can occur.
  Format: ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC).
  EOT
  default     = "sun:23:45-mon:00:30"
}

variable "multi_az" {
  type        = bool
  description = "Specifies whether the replication instance is a Multi-AZ deployment"
  default     = true
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "Specifies the virtual private cloud (VPC) security group to use with the DMS Serverless replication. The VPC security group must work with the VPC containing the replication."
  default     = []
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of the EC2 subnet IDs for the replication subnet group"
  default     = []
}
