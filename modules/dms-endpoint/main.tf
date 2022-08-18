locals {
  enabled = module.this.enabled
}

resource "aws_dms_endpoint" "default" {
  count = local.enabled ? 1 : 0

  endpoint_id   = module.this.id
  endpoint_type = var.endpoint_type

  s3_settings {
    bucket_name                      = local.bucket_name
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

  server_name = var.server_name
  username    = var.username
  password    = var.password

  engine_name                 = var.engine_name
  database_name               = var.database_name
  port                        = var.port
  ssl_mode                    = var.ssl_mode
  extra_connection_attributes = var.extra_connection_attributes

  tags = module.this.tags
}
