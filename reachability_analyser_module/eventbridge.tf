resource "aws_cloudwatch_event_rule" "network_changes_rule" {
  name        = var.aws_reachability_analyzer_eventbridge_rule_name
  description = "Rule to detect any network-related changes and trigger Lambda function"
  event_pattern = jsonencode({
    "source"        = ["aws.ec2", "aws.vpc", "aws.directconnect", "aws.globalaccelerator", "aws.route53", "aws.elbv2"],
    "detail-type"   = ["AWS API Call via CloudTrail"],
    "detail" = {
      "eventSource" = [
        "ec2.amazonaws.com",
        "vpc.amazonaws.com",
        "directconnect.amazonaws.com",
        "globalaccelerator.amazonaws.com",
        "route53.amazonaws.com",
        "elasticloadbalancing.amazonaws.com",
      ],
      "eventName" = [
        "AuthorizeSecurityGroupIngress",
        "AuthorizeSecurityGroupEgress",
        "RevokeSecurityGroupIngress",
        "RevokeSecurityGroupEgress",
        "CreateSecurityGroup",
        "DeleteSecurityGroup",
        "UpdateSecurityGroup",
        "CreateRoute",
        "DeleteRoute",
        "CreateRouteTable",
        "DeleteRouteTable",
        "ReplaceRoute",
        "ReplaceRouteTableAssociation",
        "CreateSubnet",
        "DeleteSubnet",
        "CreateVpc",
        "DeleteVpc",
        "AttachInternetGateway",
        "DetachInternetGateway",
        "CreateNatGateway",
        "DeleteNatGateway",
        "CreateVpcEndpoint",
        "DeleteVpcEndpoint",
        "CreateVpnConnection",
        "DeleteVpnConnection",
        "CreateTransitGateway",
        "DeleteTransitGateway",
        "ModifyTransitGateway",
        "AssociateTransitGatewayRouteTable",
        "DisassociateTransitGatewayRouteTable",
        "CreateTransitGatewayVpcAttachment",
        "DeleteTransitGatewayVpcAttachment",
        "CreateTransitGatewayPeeringAttachment",
        "DeleteTransitGatewayPeeringAttachment",
        "CreateCustomerGateway",
        "DeleteCustomerGateway",
        "CreateVirtualPrivateGateway",
        "DeleteVirtualPrivateGateway",
        "CreateDirectConnectGateway",
        "DeleteDirectConnectGateway",
        "CreateGlobalAccelerator",
        "DeleteGlobalAccelerator",
        "CreateLoadBalancer",
        "DeleteLoadBalancer",
        "CreateListener",
        "DeleteListener",
        "CreateTargetGroup",
        "DeleteTargetGroup",
        "CreateRouteTable",
        "DeleteRouteTable",
        "AssociateRouteTable",
        "DisassociateRouteTable",
        "ReplaceRouteTableAssociation",
        "CreateTransitGatewayRouteTable",
        "DeleteTransitGatewayRouteTable",
        "AssociateTransitGatewayRouteTable",
        "DisassociateTransitGatewayRouteTable",
        "ReplaceTransitGatewayRouteTableAssociation"
      ]
    }
  })
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.network_changes_rule.name
  target_id = "LambdaFunction"
  arn       = aws_lambda_function.start_reachability_analyzer.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.start_reachability_analyzer.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.network_changes_rule.arn
}
