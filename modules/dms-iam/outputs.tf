output "dms_redshift_s3_role_arn" {
  value       = join("", aws_iam_role.dms_redshift_s3[*].arn)
  description = "DMS Redshift S3 role ARN"
}

output "dms_cloudwatch_logs_role_arn" {
  value       = join("", aws_iam_role.dms_cloudwatch_logs[*].arn)
  description = "DMS CloudWatch Logs role ARN"
}

output "dms_vpc_management_role_arn" {
  value       = join("", aws_iam_role.dms_vpc_management[*].arn)
  description = "DMS VPC management role ARN"
}
