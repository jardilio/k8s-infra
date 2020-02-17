resource "aws_cloudwatch_log_group" "logs" {
  name = "/aws/eks/${var.name}/cluster"
  retention_in_days = 7
  kms_key_id = "${aws_kms_key.logs.arn}"
  tags = "${var.tags}"
}

resource "aws_kms_key" "logs" {
  description = "KMS key for ${var.name} cluster"
  deletion_window_in_days = 10
  enable_key_rotation = true
  tags = "${var.tags}"
}

resource "aws_flow_log" "logs" {
  iam_role_arn = "${aws_iam_role.logs.arn}"
  log_destination = "${aws_cloudwatch_log_group.logs.arn}"
  traffic_type = "ALL"
  vpc_id = "${aws_vpc.cluster.id}"
  tags = "${var.tags}"
}

resource "aws_iam_role" "logs" {
  name = "${var.name}-logs"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  tags = "${var.tags}"
}

resource "aws_iam_role_policy" "logs" {
  name = "${var.name}-logs"
  role = "${aws_iam_role.logs.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}