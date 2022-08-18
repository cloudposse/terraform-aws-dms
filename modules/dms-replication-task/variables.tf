variable "start_replication_task" {
  type        = bool
  default     = true
  description = "If set to `true`, the created replication tasks will be started automatically"
}

variable "replication_task_migration_type" {
  type        = string
  default     = "full-load-and-cdc"
  description = "The migration type. Can be one of `full-load`, `cdc`, `full-load-and-cdc`"
}
