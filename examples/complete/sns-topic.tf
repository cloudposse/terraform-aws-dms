module "sns_topic" {
  source  = "cloudposse/sns-topic/aws"
  version = "0.20.1"

  allowed_aws_services_for_sns_published = ["cloudwatch.amazonaws.com"]
  sqs_dlq_enabled                        = false
  fifo_topic                             = false
  fifo_queue_enabled                     = false
  encryption_enabled                     = false

  context = module.this.context
}
