# Data source to fetch SNS topic created in the same account.
data "aws_sns_topic" "sns_topic" {
  name = "csye6225-${var.environment}-sns"
}

locals {
  sns_topic_arn = data.aws_sns_topic.sns_topic.arn
}
