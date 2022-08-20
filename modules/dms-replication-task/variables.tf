variable "start_replication_task" {
  type        = bool
  description = "If set to `true`, the created replication tasks will be started automatically"
  default     = true
}

variable "migration_type" {
  type        = string
  description = "The migration type. Can be one of `full-load`, `cdc`, `full-load-and-cdc`"
  default     = "full-load-and-cdc"
}

variable "cdc_start_position" {
  type        = string
  description = "Indicates when you want a change data capture (CDC) operation to start. The value can be in date, checkpoint, or LSN/SCN format depending on the source engine, Conflicts with `cdc_start_time`"
  default     = null
}

variable "cdc_start_time" {
  type        = string
  description = "The Unix timestamp integer for the start of the Change Data Capture (CDC) operation. Conflicts with `cdc_start_position`"
  default     = null
}

variable "replication_instance_arn" {
  type        = string
  description = "The Amazon Resource Name (ARN) of the replication instance"
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

variable "replication_task_settings" {
  type        = string
  description = "An escaped JSON string that contains the task settings. See https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TaskSettings.html for more details"
  default     = null
}
