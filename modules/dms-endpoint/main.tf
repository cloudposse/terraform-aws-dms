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
      error_retry_duration       = var.elasticsearch_settings["error_retry_duration"]
      full_load_error_percentage = var.elasticsearch_settings["full_load_error_percentage"]
    }
  }

  dynamic "kafka_settings" {
    for_each = var.kafka_settings != null ? [true] : []
    content {
      broker                         = lookup(var.kafka_settings, "broker")
      include_control_details        = var.kafka_settings["include_control_details"]
      include_null_and_empty         = var.kafka_settings["include_null_and_empty"]
      include_partition_value        = var.kafka_settings["include_partition_value"]
      include_table_alter_operations = var.kafka_settings["include_table_alter_operations"]
      include_transaction_details    = var.kafka_settings["include_transaction_details"]
      message_format                 = var.kafka_settings["message_format"]
      message_max_bytes              = var.kafka_settings["message_max_bytes"]
      no_hex_prefix                  = var.kafka_settings["no_hex_prefix"]
      partition_include_schema_table = var.kafka_settings["partition_include_schema_table"]
      sasl_password                  = var.kafka_settings["sasl_password"]
      sasl_username                  = var.kafka_settings["sasl_username"]
      security_protocol              = var.kafka_settings["security_protocol"]
      ssl_ca_certificate_arn         = var.kafka_settings["ssl_ca_certificate_arn"]
      ssl_client_certificate_arn     = var.kafka_settings["ssl_client_certificate_arn"]
      ssl_client_key_arn             = var.kafka_settings["ssl_client_key_arn"]
      ssl_client_key_password        = var.kafka_settings["ssl_client_key_password"]
      topic                          = var.kafka_settings["topic"]
    }
  }

  dynamic "kinesis_settings" {
    for_each = var.kinesis_settings != null ? [true] : []
    content {
      include_control_details        = var.kinesis_settings["include_control_details"]
      include_null_and_empty         = var.kinesis_settings["include_null_and_empty"]
      include_partition_value        = var.kinesis_settings["include_partition_value"]
      include_table_alter_operations = var.kinesis_settings["include_table_alter_operations"]
      include_transaction_details    = var.kinesis_settings["include_transaction_details"]
      message_format                 = var.kinesis_settings["message_format"]
      partition_include_schema_table = var.kinesis_settings["partition_include_schema_table"]
      service_access_role_arn        = var.kinesis_settings["service_access_role_arn"]
      stream_arn                     = var.kinesis_settings["stream_arn"]
    }
  }

  dynamic "mongodb_settings" {
    for_each = var.mongodb_settings != null ? [true] : []
    content {
      auth_mechanism      = var.mongodb_settings["auth_mechanism"]
      auth_source         = var.mongodb_settings["auth_source"]
      auth_type           = var.mongodb_settings["auth_type"]
      docs_to_investigate = var.mongodb_settings["docs_to_investigate"]
      extract_doc_id      = var.mongodb_settings["extract_doc_id"]
      nesting_level       = var.mongodb_settings["nesting_level"]
    }
  }

  dynamic "redshift_settings" {
    for_each = var.redshift_settings != null ? [true] : []
    content {
      bucket_folder                     = var.redshift_settings["bucket_folder"]
      bucket_name                       = var.redshift_settings["bucket_name"]
      encryption_mode                   = var.redshift_settings["encryption_mode"]
      server_side_encryption_kms_key_id = var.redshift_settings["server_side_encryption_kms_key_id"]
      service_access_role_arn           = var.redshift_settings["service_access_role_arn"]
    }
  }

  dynamic "s3_settings" {
    for_each = var.s3_settings != null ? [true] : []
    content {
      bucket_name                                 = lookup(var.s3_settings, "bucket_name")
      add_column_name                             = var.s3_settings["add_column_name"]
      bucket_folder                               = var.s3_settings["bucket_folder"]
      canned_acl_for_objects                      = var.s3_settings["canned_acl_for_objects"]
      cdc_inserts_and_updates                     = var.s3_settings["cdc_inserts_and_updates"]
      cdc_inserts_only                            = var.s3_settings["cdc_inserts_only"]
      cdc_max_batch_interval                      = var.s3_settings["cdc_max_batch_interval"]
      cdc_min_file_size                           = var.s3_settings["cdc_min_file_size"]
      cdc_path                                    = var.s3_settings["cdc_path"]
      compression_type                            = var.s3_settings["compression_type"]
      csv_delimiter                               = var.s3_settings["csv_delimiter"]
      csv_no_sup_value                            = var.s3_settings["csv_no_sup_value"]
      csv_null_value                              = var.s3_settings["csv_null_value"]
      csv_row_delimiter                           = var.s3_settings["csv_row_delimiter"]
      data_format                                 = var.s3_settings["data_format"]
      data_page_size                              = var.s3_settings["data_page_size"]
      date_partition_delimiter                    = var.s3_settings["date_partition_delimiter"]
      date_partition_enabled                      = var.s3_settings["date_partition_enabled"]
      date_partition_sequence                     = var.s3_settings["date_partition_sequence"]
      dict_page_size_limit                        = var.s3_settings["dict_page_size_limit"]
      enable_statistics                           = var.s3_settings["enable_statistics"]
      encoding_type                               = var.s3_settings["encoding_type"]
      encryption_mode                             = var.s3_settings["encryption_mode"]
      external_table_definition                   = var.s3_settings["external_table_definition"]
      include_op_for_full_load                    = var.s3_settings["include_op_for_full_load"]
      max_file_size                               = var.s3_settings["max_file_size"]
      parquet_timestamp_in_millisecond            = var.s3_settings["parquet_timestamp_in_millisecond"]
      parquet_version                             = var.s3_settings["parquet_version"]
      preserve_transactions                       = var.s3_settings["preserve_transactions"]
      rfc_4180                                    = var.s3_settings["rfc_4180"]
      row_group_length                            = var.s3_settings["row_group_length"]
      server_side_encryption_kms_key_id           = var.s3_settings["server_side_encryption_kms_key_id"]
      service_access_role_arn                     = var.s3_settings["service_access_role_arn"]
      timestamp_column_name                       = var.s3_settings["timestamp_column_name"]
      use_task_start_time_for_full_load_timestamp = var.s3_settings["use_task_start_time_for_full_load_timestamp"]
      use_csv_no_sup_value                        = var.s3_settings["use_csv_no_sup_value"]
    }
  }

  tags = module.this.tags
}
