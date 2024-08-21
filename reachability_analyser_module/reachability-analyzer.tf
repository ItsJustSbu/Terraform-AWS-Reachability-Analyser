resource "aws_ec2_network_insights_path" "reachability_paths" {
  for_each = { for idx, path in var.reachability_analyzer_paths : idx => path }

  source_ip        = each.value.source_ip
  protocol         = each.value.protocol
  source           = each.value.source_id
  destination      = each.value.destination_id
  destination_port = each.value.destination_port
  tags = {
    name = each.value.name
  }
}