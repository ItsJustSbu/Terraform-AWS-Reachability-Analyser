
variable "aws_reachability_analyzer_cloudtrail" {
  description = "The name of the S3 bucket to store Reachability Analyzer CloudTrail logs"
  type        = string
}

variable "aws_reachability_analyzer_cloudtrail_bucket" {
  description = "value of the S3 bucket to store Reachability Analyzer CloudTrail logs"
  type        = string
}

variable "aws_reachability_analyzer_eventbridge_rule_name" {
  description = "The name of the EventBridge rule for Reachability Analyzer"
  type        = string
}

variable "aws_reachability_analyzer_lambda_role_name" {
  description = "The name of the IAM role for Reachability Analyzer Lambda function"
  type        = string
}

variable "aws_reachability_analyzer_lambda_policy_name" {
  description = "The name of the IAM policy for Reachability Analyzer Lambda function"
  type        = string
}

variable "aws_reachability_analyzer_lambda_function_name" {
  description = "The name of the Lambda function for Reachability Analyzer"
  type        = string
}
variable "reachability_analyzer_paths" {
  type = list(object({
    source_ip        = optional(string)
    source_id        = optional(string)
    destination_ip  = optional(string)
    destination_id   = optional(string)
    protocol         = string
    destination_port = number
    name             = string
  }))

  description = "The list of Reachability Analyzer paths"
}


variable "reachability_analyzer_topic_name" {
  description = "value of the SNS topic for Reachability Analyzer"
  type        = string
}

variable "reachability_analyzer_topic_subscription_email" {
  description = "The email address for the SNS topic subscription"
  type        = string
}

variable "aws_reachability_analyzer_path_name" {
  description = "The name of the Reachability Analyzer path"
  type        = string
}