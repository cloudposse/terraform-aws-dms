variable "endpoint_type" {
  type        = string
  description = "Type of endpoint. Valid values are `source`, `target`"
}

variable "engine_name" {
  type        = string
  description = "Type of engine for the endpoint. Valid values are `aurora`, `aurora-postgresql`, `azuredb`, `db2`, `docdb`, `dynamodb`, `elasticsearch`, `kafka`, `kinesis`, `mariadb`, `mongodb`, `mysql`, `opensearch`, `oracle`, `postgres`, `redshift`, `s3`, `sqlserver`, `sybase`"
}

variable "kms_key_arn" {
  type        = string
  description = "(Required when engine_name is `mongodb`, optional otherwise). ARN for the KMS key that will be used to encrypt the connection parameters. If you do not specify a value for `kms_key_arn`, then AWS DMS will use your default encryption key"
  default     = null
}

variable "certificate_arn" {
  type        = string
  description = "Certificate ARN"
  default     = null
}

variable "database_name" {
  type        = string
  description = "Name of the endpoint database"
  default     = null
}

variable "password" {
  type        = string
  description = "Password to be used to login to the endpoint database"
  default     = null
}

variable "port" {
  type        = number
  description = "Port used by the endpoint database"
  default     = null
}

variable "extra_connection_attributes" {
  type        = string
  description = "Additional attributes associated with the connection to the source database"
  default     = ""
}

variable "secrets_manager_access_role_arn" {
  type        = string
  description = "ARN of the IAM role that specifies AWS DMS as the trusted entity and has the required permissions to access the value in SecretsManagerSecret"
  default     = null
}

variable "secrets_manager_arn" {
  type        = string
  description = "Full ARN, partial ARN, or friendly name of the SecretsManagerSecret that contains the endpoint connection details. Supported only for engine_name as aurora, aurora-postgresql, mariadb, mongodb, mysql, oracle, postgres, redshift or sqlserver"
  default     = null
}

variable "server_name" {
  type        = string
  description = "Host name of the database server"
  default     = null
}

variable "service_access_role" {
  type        = string
  description = "ARN used by the service access IAM role for dynamodb endpoints"
  default     = null
}

variable "ssl_mode" {
  type        = string
  description = "The SSL mode to use for the connection. Can be one of `none`, `require`, `verify-ca`, `verify-full`"
  default     = "none"
}

variable "username" {
  type        = string
  description = "User name to be used to login to the endpoint database"
  default     = null
}

variable "elasticsearch_settings" {
  type        = map(any)
  description = "Configuration block for OpenSearch settings"
  default     = null
}

variable "kafka_settings" {
  type        = map(any)
  description = "Configuration block for Kafka settings"
  default     = null
}

variable "kinesis_settings" {
  type        = map(any)
  description = "Configuration block for Kinesis settings"
  default     = null
}

variable "mongodb_settings" {
  type        = map(any)
  description = "Configuration block for MongoDB settings"
  default     = null
}

variable "postgres_settings" {
  description = "Configuration block for Postgres settings"
  default     = null
  type = object({
    after_connect_script         = optional(string, null)
    babelfish_database_name      = optional(string, null)
    capture_ddls                 = optional(string, null)
    database_mode                = optional(string, null)
    ddl_artifacts_schema         = optional(string, "public")
    execute_timeout              = optional(number, 60)
    fail_tasks_on_lob_truncation = optional(bool, false)
    heartbeat_enable             = optional(bool, false)
    heartbeat_frequency          = optional(number, 5)
    heartbeat_schema             = optional(string, false)
    map_boolean_as_boolean       = optional(bool, false)
    map_jsonb_as_clob            = optional(bool, false)
    map_long_varchar_as          = optional(string, "")
    max_file_size                = optional(number, null)
    plugin_name                  = optional(string, null)
    slot_name                    = optional(string, null)
  })
}

variable "redshift_settings" {
  type        = map(any)
  description = "Configuration block for Redshift settings"
  default     = null
}

variable "s3_settings" {
  type = object({
    bucket_name                                 = string
    service_access_role_arn                     = string
    bucket_folder                               = optional(string, null)
    cdc_inserts_only                            = optional(bool, false)
    csv_row_delimiter                           = optional(string, null)
    csv_delimiter                               = optional(string, null)
    data_format                                 = optional(string, null)
    compression_type                            = optional(string, null)
    date_partition_delimiter                    = optional(string, null)
    date_partition_enabled                      = optional(bool, false)
    date_partition_sequence                     = optional(string, null)
    include_op_for_full_load                    = optional(bool, false)
    parquet_timestamp_in_millisecond            = optional(bool, false)
    timestamp_column_name                       = optional(string, null)
    use_csv_no_sup_value                        = optional(bool, false)
    use_task_start_time_for_full_load_timestamp = optional(bool, false)
    add_column_name                             = optional(string, null)
    dict_page_size_limit                        = optional(number, null)
    enable_statistics                           = optional(bool, false)
    encoding_type                               = optional(string, null)
    encryption_mode                             = optional(string, null)
    external_table_definition                   = optional(string, null)
    max_file_size                               = optional(number, null)
    parquet_version                             = optional(string, null)
    preserve_transactions                       = optional(bool, false)
    rfc_4180                                    = optional(bool, false)
    row_group_length                            = optional(number, null)
    server_side_encryption_kms_key_id           = optional(string, null)
    cdc_inserts_and_updates                     = optional(bool, false)
    cdc_max_batch_interval                      = optional(number, null)
    cdc_min_file_size                           = optional(number, null)
    cdc_path                                    = optional(string, null)
    cdc_path_prefix                             = optional(string, null)
    cdc_timestamp_column_name                   = optional(string, null)
    cdc_timestamp_format                        = optional(string, null)
    cdc_timestamp_type                          = optional(string, null)
    ignore_header_rows                          = optional(bool, false)
  })
  nullable    = true
  description = "Configuration block for S3 settings"
  default     = null
}
