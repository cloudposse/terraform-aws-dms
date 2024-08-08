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
      endpoint_uri               = lookup(var.elasticsearch_settings, "endpoint_uri")
      service_access_role_arn    = lookup(var.elasticsearch_settings, "service_access_role_arn")
      error_retry_duration       = lookup(var.elasticsearch_settings, "error_retry_duration", null)
      full_load_error_percentage = lookup(var.elasticsearch_settings, "full_load_error_percentage", null)
    }
  }

  dynamic "kafka_settings" {
    for_each = var.kafka_settings != null ? [true] : []
    content {
      broker                         = lookup(var.kafka_settings, "broker")
      include_control_details        = lookup(var.kafka_settings, "include_control_details", null)
      include_null_and_empty         = lookup(var.kafka_settings, "include_null_and_empty", null)
      include_partition_value        = lookup(var.kafka_settings, "include_partition_value", null)
      include_table_alter_operations = lookup(var.kafka_settings, "include_table_alter_operations", null)
      include_transaction_details    = lookup(var.kafka_settings, "include_transaction_details", null)
      message_format                 = lookup(var.kafka_settings, "message_format", null)
      message_max_bytes              = lookup(var.kafka_settings, "message_max_bytes", null)
      no_hex_prefix                  = lookup(var.kafka_settings, "no_hex_prefix", null)
      partition_include_schema_table = lookup(var.kafka_settings, "partition_include_schema_table", null)
      sasl_password                  = lookup(var.kafka_settings, "sasl_password", null)
      sasl_username                  = lookup(var.kafka_settings, "sasl_username", null)
      security_protocol              = lookup(var.kafka_settings, "security_protocol", null)
      ssl_ca_certificate_arn         = lookup(var.kafka_settings, "ssl_ca_certificate_arn", null)
      ssl_client_certificate_arn     = lookup(var.kafka_settings, "ssl_client_certificate_arn", null)
      ssl_client_key_arn             = lookup(var.kafka_settings, "ssl_client_key_arn", null)
      ssl_client_key_password        = lookup(var.kafka_settings, "ssl_client_key_password", null)
      topic                          = lookup(var.kafka_settings, "topic", null)
    }
  }

  dynamic "kinesis_settings" {
    for_each = var.kinesis_settings != null ? [true] : []
    content {
      include_control_details        = lookup(var.kinesis_settings, "include_control_details", null)
      include_null_and_empty         = lookup(var.kinesis_settings, "include_null_and_empty", null)
      include_partition_value        = lookup(var.kinesis_settings, "include_partition_value", null)
      include_table_alter_operations = lookup(var.kinesis_settings, "include_table_alter_operations", null)
      include_transaction_details    = lookup(var.kinesis_settings, "include_transaction_details", null)
      message_format                 = lookup(var.kinesis_settings, "message_format", null)
      partition_include_schema_table = lookup(var.kinesis_settings, "partition_include_schema_table", null)
      service_access_role_arn        = lookup(var.kinesis_settings, "service_access_role_arn", null)
      stream_arn                     = lookup(var.kinesis_settings, "stream_arn", null)
    }
  }

  dynamic "mongodb_settings" {
    for_each = var.mongodb_settings != null ? [true] : []
    content {
      auth_mechanism      = lookup(var.mongodb_settings, "auth_mechanism", null)
      auth_source         = lookup(var.mongodb_settings, "auth_source", null)
      auth_type           = lookup(var.mongodb_settings, "auth_type", null)
      docs_to_investigate = lookup(var.mongodb_settings, "docs_to_investigate", null)
      extract_doc_id      = lookup(var.mongodb_settings, "extract_doc_id", null)
      nesting_level       = lookup(var.mongodb_settings, "nesting_level", null)
    }
  }

  dynamic "redshift_settings" {
    for_each = var.redshift_settings != null ? [true] : []
    content {
      bucket_folder                     = lookup(var.redshift_settings, "bucket_folder", null)
      bucket_name                       = lookup(var.redshift_settings, "bucket_name", null)
      encryption_mode                   = lookup(var.redshift_settings, "encryption_mode", null)
      server_side_encryption_kms_key_id = lookup(var.redshift_settings, "server_side_encryption_kms_key_id", null)
      service_access_role_arn           = lookup(var.redshift_settings, "service_access_role_arn", null)
    }
  }

  dynamic "s3_settings" {
    for_each = var.s3_settings != null ? [true] : []
    content {
      bucket_name                                 = lookup(var.s3_settings, "bucket_name")
      add_column_name                             = lookup(var.s3_settings, "add_column_name", null)
      bucket_folder                               = lookup(var.s3_settings, "bucket_folder", null)
      canned_acl_for_objects                      = lookup(var.s3_settings, "canned_acl_for_objects", null)
      cdc_inserts_and_updates                     = lookup(var.s3_settings, "cdc_inserts_and_updates", null)
      cdc_inserts_only                            = lookup(var.s3_settings, "cdc_inserts_only", null)
      cdc_max_batch_interval                      = lookup(var.s3_settings, "cdc_max_batch_interval", null)
      cdc_min_file_size                           = lookup(var.s3_settings, "cdc_min_file_size", null)
      cdc_path                                    = lookup(var.s3_settings, "cdc_path", null)
      compression_type                            = lookup(var.s3_settings, "compression_type", null)
      csv_delimiter                               = lookup(var.s3_settings, "csv_delimiter", null)
      csv_no_sup_value                            = lookup(var.s3_settings, "csv_no_sup_value", null)
      csv_null_value                              = lookup(var.s3_settings, "csv_null_value", null)
      csv_row_delimiter                           = lookup(var.s3_settings, "csv_row_delimiter", null)
      data_format                                 = lookup(var.s3_settings, "data_format", null)
      data_page_size                              = lookup(var.s3_settings, "data_page_size", null)
      date_partition_delimiter                    = lookup(var.s3_settings, "date_partition_delimiter", null)
      date_partition_enabled                      = lookup(var.s3_settings, "date_partition_enabled", null)
      date_partition_sequence                     = lookup(var.s3_settings, "date_partition_sequence", null)
      dict_page_size_limit                        = lookup(var.s3_settings, "dict_page_size_limit", null)
      enable_statistics                           = lookup(var.s3_settings, "enable_statistics", null)
      encoding_type                               = lookup(var.s3_settings, "encoding_type", null)
      encryption_mode                             = lookup(var.s3_settings, "encryption_mode", null)
      external_table_definition                   = lookup(var.s3_settings, "external_table_definition", null)
      include_op_for_full_load                    = lookup(var.s3_settings, "include_op_for_full_load", null)
      max_file_size                               = lookup(var.s3_settings, "max_file_size", null)
      parquet_timestamp_in_millisecond            = lookup(var.s3_settings, "parquet_timestamp_in_millisecond", null)
      parquet_version                             = lookup(var.s3_settings, "parquet_version", null)
      preserve_transactions                       = lookup(var.s3_settings, "preserve_transactions", null)
      rfc_4180                                    = lookup(var.s3_settings, "rfc_4180", null)
      row_group_length                            = lookup(var.s3_settings, "row_group_length", null)
      server_side_encryption_kms_key_id           = lookup(var.s3_settings, "server_side_encryption_kms_key_id", null)
      service_access_role_arn                     = lookup(var.s3_settings, "service_access_role_arn", null)
      timestamp_column_name                       = lookup(var.s3_settings, "timestamp_column_name", null)
      use_task_start_time_for_full_load_timestamp = lookup(var.s3_settings, "use_task_start_time_for_full_load_timestamp", null)
      use_csv_no_sup_value                        = lookup(var.s3_settings, "use_csv_no_sup_value", null)
    }
  }

  tags = module.this.tags
}
