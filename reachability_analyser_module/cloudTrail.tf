
resource "aws_cloudtrail" "aws_reachability_analyzer_cloudtrail" {
  depends_on = [aws_s3_bucket_policy.aws_reachability_analyzer_cloudtrail_bucket_policy_attachment]
  
  name                          = var.aws_reachability_analyzer_cloudtrail
  s3_bucket_name                = aws_s3_bucket.aws_reachability_analyzer_cloudtrail_bucket.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = false
}

resource "aws_s3_bucket" "aws_reachability_analyzer_cloudtrail_bucket" {
  bucket        = var.aws_reachability_analyzer_cloudtrail_bucket
  force_destroy = true
}

data "aws_iam_policy_document" "aws_reachability_analyzer_cloudtrail_bucket_policy" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.aws_reachability_analyzer_cloudtrail_bucket.arn]
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.aws_reachability_analyzer_cloudtrail_bucket.arn}/prefix/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}


resource "aws_s3_bucket_policy" "aws_reachability_analyzer_cloudtrail_bucket_policy_attachment" {
  bucket = aws_s3_bucket.aws_reachability_analyzer_cloudtrail_bucket.id
  policy = data.aws_iam_policy_document.aws_reachability_analyzer_cloudtrail_bucket_policy.json
}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}
