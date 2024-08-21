provider "aws" {
  region = "eu-west-1"
}


module "reeachability_analyser" {
  source = "./reachability_analyser_module"
  aws_reachability_analyzer_lambda_function_name = "my_lambda_function"
  reachability_analyzer_topic_subscription_email = "sibusiso@synthesis.co.za"
  reachability_analyzer_paths = [
    {
        source_id = "igw-00278f01f0ddcb95b",
        destination_id = "i-050cbbba9ffbebcf0",
        destination_port = 80,
        protocol = "tcp",
        name = "test_path_1"
        
    }
  ]
  aws_reachability_analyzer_lambda_role_name = "my_lambda_role"
  aws_reachability_analyzer_path_name = "test_path"
  aws_reachability_analyzer_lambda_policy_name = "my_lambda_policy"
  aws_reachability_analyzer_cloudtrail = "my_cloudtrail"
  reachability_analyzer_topic_name = "my_topic"
  aws_reachability_analyzer_eventbridge_rule_name = "my_eventbridge_rule"
  aws_reachability_analyzer_cloudtrail_bucket = "reachability-cloudtrail-bucket-sbu-012-123-0744-22-c07"
}