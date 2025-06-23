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
      endpoint_uri               = var.elasticsearch_settings["endpoint_uri"]
      service_access_role_arn    = var.elasticsearch_settings["service_access_role_arn"]
      error_retry_duration       = lookup(var.elasticsearch_settings, "error_retry_duration", null)
      full_load_error_percentage = lookup(var.elasticsearch_settings, "full_load_error_percentage", null)
    }
  }

  dynamic "kafka_settings" {
    for_each = var.kafka_settings != null ? [true] : []
    content {
      broker                         = var.kafka_settings["broker"]
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

  dynamic "postgres_settings" {
    for_each = var.postgres_settings != null ? [var.postgres_settings] : []
    content {
      after_connect_script         = postgres_settings.value.after_connect_script
      babelfish_database_name      = postgres_settings.value.babelfish_database_name
      capture_ddls                 = postgres_settings.value.capture_ddls
      database_mode                = postgres_settings.value.database_mode
      ddl_artifacts_schema         = postgres_settings.value.ddl_artifacts_schema
      execute_timeout              = postgres_settings.value.execute_timeout
      fail_tasks_on_lob_truncation = postgres_settings.value.fail_tasks_on_lob_truncation
      heartbeat_enable             = postgres_settings.value.heartbeat_enable
      heartbeat_frequency          = postgres_settings.value.heartbeat_frequency
      heartbeat_schema             = postgres_settings.value.heartbeat_schema
      map_boolean_as_boolean       = postgres_settings.value.map_boolean_as_boolean
      map_jsonb_as_clob            = postgres_settings.value.map_jsonb_as_clob
      map_long_varchar_as          = postgres_settings.value.map_long_varchar_as
      max_file_size                = postgres_settings.value.max_file_size
      plugin_name                  = postgres_settings.value.plugin_name
      slot_name                    = postgres_settings.value.slot_name
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

  tags = module.this.tags
}
