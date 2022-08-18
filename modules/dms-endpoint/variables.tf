variable "endpoint_type" {
  type        = string
  description = "Endpoint type"
}

variable "engine_name" {
  type        = string
  description = "The type of engine for the endpoint"
}

variable "port" {
  type        = number
  description = "The port used by the source endpoint database"
}

variable "ssl_mode" {
  type        = string
  default     = "none"
  description = "The SSL mode to use for the connection. Can be one of `none`, `require`, `verify-ca`, `verify-full`"
}

variable "extra_connection_attributes" {
  type        = string
  default     = ""
  description = "Additional attributes associated with the connection to the source database"
}

variable "service_access_role_arn" {
  type        = string
  default     = null
  description = "Service access role ARN"
}
