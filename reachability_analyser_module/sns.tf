resource "aws_sns_topic" "reachability_analyzer_topic" {
  name = var.reachability_analyzer_topic_name
}


resource "aws_sns_topic_subscription" "reachability_analyzer_topic_subscription" {
  topic_arn = aws_sns_topic.reachability_analyzer_topic.arn
  protocol  = "email"
  endpoint  = var.reachability_analyzer_topic_subscription_email
}