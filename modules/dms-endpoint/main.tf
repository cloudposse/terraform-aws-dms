locals {
  enabled = module.this.enabled
}

resource "aws_dms_endpoint" "default" {
  count = local.enabled ? 1 : 0

  endpoint_id                     = module.this.id
  endpoint_type                   = var.endpoint_type
  engine_name                     = var.engine_name
  kms_key_arn                     = var.kms_key_arn
  certificate_arn                 = var.certificate_arn
  database_name                   = var.database_name
  extra_connection_attributes     = var.extra_connection_attributes
  port                            = var.port
  server_name                     = var.server_name
  username                        = var.username
  password                        = var.password
  secrets_manager_access_role_arn = var.secrets_manager_access_role_arn
  secrets_manager_arn             = var.secrets_manager_arn
  service_access_role             = var.service_access_role
  ssl_mode                        = var.ssl_mode

  dynamic "elasticsearch_settings" {
    for_each = var.elasticsearch_settings != null ? [true] : []
    content {
      endpoint_uri               = var.elasticsearch_settings.endpoint_uri
      error_retry_duration       = lookup(var.elasticsearch_settings, "error_retry_duration", null)
      full_load_error_percentage = lookup(var.elasticsearch_settings, "full_load_error_percentage", null)
      service_access_role_arn    = var.elasticsearch_settings.service_access_role_arn
    }
  }

  dynamic "kafka_settings" {
    for_each = var.kafka_settings != null ? [true] : []
    content {
      broker = ""
    }
  }

  dynamic "kinesis_settings" {
    for_each = var.kinesis_settings != null ? [true] : []
    content {
    }
  }

  dynamic "mongodb_settings" {
    for_each = var.mongodb_settings != null ? [true] : []
    content {
    }
  }

  dynamic "redshift_settings" {
    for_each = var.redshift_settings != null ? [true] : []
    content {
    }
  }

  dynamic "s3_settings" {
    for_each = var.s3_settings != null ? [true] : []
    content {
      bucket_name                      = var.bucket_name
      bucket_folder                    = var.target_bucket_folder
      compression_type                 = var.target_compression_type
      csv_delimiter                    = var.target_csv_delimiter
      csv_row_delimiter                = var.target_csv_row_delimiter
      data_format                      = var.target_data_format
      date_partition_enabled           = var.target_date_partition_enabled
      external_table_definition        = var.target_external_table_definition
      parquet_timestamp_in_millisecond = var.target_parquet_timestamp_in_millisecond
      service_access_role_arn          = var.service_access_role_arn
    }
  }

  tags = module.this.tags
}
