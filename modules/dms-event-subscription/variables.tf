variable "event_subscription_enabled" {
  type        = bool
  description = "Whether the event subscription should be enabled"
  default     = true
}

variable "event_categories" {
  type        = list(string)
  description = "List of event categories to listen for"
  default     = null
}

variable "sns_topic_arn" {
  type        = string
  description = "SNS topic arn to send events on"
}

variable "source_ids" {
  type        = list(string)
  description = "Ids of sources to listen to"
}

variable "source_type" {
  type        = string
  description = "Type of source for events. Valid values: `replication-instance` or `replication-task`"
}
