resource "aws_iam_role" "lambda_role" {
  name = var.aws_reachability_analyzer_lambda_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = var.aws_reachability_analyzer_lambda_policy_name
  role = aws_iam_role.lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "ec2:GetTransitGatewayRouteTablePropagations",
             "ec2:DescribeTransitGatewayPeeringAttachments",
             "ec2:SearchTransitGatewayRoutes",
             "ec2:DescribeTransitGatewayRouteTables",
             "ec2:DescribeTransitGatewayVpcAttachments",
             "ec2:DescribeTransitGatewayAttachments",
             "ec2:DescribeTransitGateways",
             "ec2:GetManagedPrefixListEntries",
             "ec2:DescribeManagedPrefixLists",
             "ec2:DescribeAvailabilityZones",
             "ec2:DescribeCustomerGateways",
             "ec2:DescribeInstances",
             "ec2:DescribeInternetGateways",
             "ec2:DescribeNatGateways",
             "ec2:DescribeNetworkAcls",
             "ec2:DescribeNetworkInterfaces",
             "ec2:DescribePrefixLists",
             "ec2:DescribeRegions",
             "ec2:DescribeRouteTables",
             "ec2:DescribeSecurityGroups",
             "ec2:DescribeSubnets",
             "ec2:DescribeVpcEndpoints",
             "ec2:DescribeVpcPeeringConnections",
             "ec2:DescribeVpcs",
             "ec2:DescribeVpnConnections",
             "ec2:DescribeVpnGateways",
             "ec2:DescribeVpcEndpointServiceConfigurations",
             "elasticloadbalancing:DescribeListeners",
             "elasticloadbalancing:DescribeLoadBalancers",
             "elasticloadbalancing:DescribeLoadBalancerAttributes",
             "elasticloadbalancing:DescribeRules",
             "elasticloadbalancing:DescribeTags",
             "elasticloadbalancing:DescribeTargetGroups",
             "elasticloadbalancing:DescribeTargetHealth",
             "tiros:CreateQuery",
             "tiros:GetQueryAnswer",
             "tiros:GetQueryExplanation",
             "ec2:CreateTags",
             "ec2:DeleteTags",
             "ec2:StartNetworkInsightsAnalysis",
             "ec2:DescribeNetworkInsightsAnalyses",
             "ec2:DescribeNetworkInsightsPaths"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "sns:Publish"
        ],
        Resource = "${aws_sns_topic.reachability_analyzer_topic.arn}"
      }
    ]
  })
}

locals {
  path_ids_string = join(",", [for key, path in aws_ec2_network_insights_path.reachability_paths : path.id])
}

resource "aws_lambda_function" "start_reachability_analyzer" {
  function_name = var.aws_reachability_analyzer_lambda_function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "main.handler"
  runtime       = "python3.11"
  timeout       = 900
  filename      = "${path.module}/placeholder.zip"
  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.reachability_analyzer_topic.arn,
      REACHABILITY_PATH_IDS = local.path_ids_string
    }
  }
}