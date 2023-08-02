#####################
# Flow Logs
#####################

### IAM
data "aws_iam_policy_document" "flow_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "flow_logs_policy" {
  statement {
    actions = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents", "logs:DescribeLogGroups", "logs:DescribeLogStreams"]
    effect  = "Allow"
    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
}

resource "aws_iam_role" "flow_role" {
  name               = "${var.service_name}-flow-role"
  description        = "Role for VPC Flow Logs for ${var.service_name}"
  assume_role_policy = data.aws_iam_policy_document.flow_assume_role.json
  tags = merge(
    {
      Name = "${var.service_name}-flow-role"
    },
    var.common_tags
  )
}

resource "aws_iam_role_policy" "flow_policy" {
  name   = "${var.service_name}-flow-policy"
  role   = aws_iam_role.flow_role.id
  policy = data.aws_iam_policy_document.flow_logs_policy.json
}

resource "aws_cloudwatch_log_group" "flow_logs" {
  name              = "${var.service_name}-flow-logs"
  retention_in_days = 30
  tags = merge(
    {
      Name = "${var.service_name}-flow-logs"
    },
    var.common_tags
  )
}

resource "aws_flow_log" "flow_logs" {
  iam_role_arn    = aws_iam_role.flow_role.arn
  log_destination = aws_cloudwatch_log_group.flow_logs.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.this.id
  tags = merge(
    {
      Name = "${var.service_name}-${aws_vpc.this.id}-flow-logs"
    },
    var.common_tags
  )
}