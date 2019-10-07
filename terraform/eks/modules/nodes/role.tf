resource "aws_iam_role" "role" {
  name = "${identifier}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
    tags = "${var.tags}"
}

resource "aws_iam_role_policy_attachment" "role_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.role.name}"
}

resource "aws_iam_role_policy_attachment" "role_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.role.name}"
}

resource "aws_iam_role_policy_attachment" "role_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.role.name}"
}

resource "aws_iam_instance_profile" "role" {
  name = "${identifier}"
  role = "${aws_iam_role.role.name}"
  tags = "${var.tags}"
}