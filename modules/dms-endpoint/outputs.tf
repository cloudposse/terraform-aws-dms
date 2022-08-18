output "endpoint_id" {
  value       = join("", aws_dms_endpoint.default.*.id)
  description = "Endpoint ID"
}

output "endpoint_arn" {
  value       = join("", aws_dms_endpoint.default.*.endpoint_arn)
  description = "Endpoint ARN"
}
