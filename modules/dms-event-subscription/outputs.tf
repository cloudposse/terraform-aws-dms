output "event_subscription_arn" {
  value       = join("", aws_dms_event_subscription.default.*.arn)
  description = "Event subscription ARN"
}
