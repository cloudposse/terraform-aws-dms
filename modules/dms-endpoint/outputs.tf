output "endpoint_id" {
  value       = local.enabled && var.engine_name != "s3" ? join("", aws_dms_endpoint.default[*].id) : join("", aws_dms_s3_endpoint.default[*].id)
  description = "Endpoint ID"
}

output "endpoint_arn" {
  value       = local.enabled && var.engine_name != "s3" ? join("", aws_dms_endpoint.default[*].endpoint_arn) : join("", aws_dms_s3_endpoint.default[*].endpoint_arn)
  description = "Endpoint ARN"
}
