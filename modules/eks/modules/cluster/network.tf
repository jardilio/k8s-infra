locals {
  public_cidr = "${var.public_cidr == "" ? cidrsubnet(var.cidr, ceil(log(2,2)), 0) : var.public_cidr}"
  private_cidr = "${var.private_cidr == "" ? cidrsubnet(var.cidr, ceil(log(2,2)), 1) : var.private_cidr}"
}

resource "aws_vpc" "network" {
  cidr_block = "${var.cidr}"
  tags = "${
    merge(
        var.tags,
        map("kubernetes.io/cluster/${var.name}", "shared")
    )
  }"
}

resource "aws_flow_log" "network" {
  iam_role_arn = "${aws_iam_role.logs.arn}"
  log_destination = "${aws_cloudwatch_log_group.logs.arn}"
  traffic_type = "ALL"
  vpc_id = "${aws_vpc.network}"
}

resource "aws_subnet" "network_public" {
  count = "${length(var.zones)}"
  availability_zone = "${element(var.zones, count.index)}"
  cidr_block = "${cidrsubnet(local.public_cidr, ceil(log(length(var.zones),2)), count.index)}"
  vpc_id = "${aws_vpc.network.id}"
  tags = "${
    merge(
        var.tags,
        map("kubernetes.io/cluster/${var.name}", "shared")
    )
  }"
}

resource "aws_subnet" "network_private" {
  count = "${length(var.zones)}"
  availability_zone = "${element(var.zones, count.index)}"
  cidr_block = "${cidrsubnet(local.private_cidr, ceil(log(length(var.zones),2)), count.index)}"
  vpc_id = "${aws_vpc.network.id}"
  tags = "${
    merge(
        var.tags,
        map("kubernetes.io/cluster/${var.name}", "shared")
    )
  }"
}

resource "aws_internet_gateway" "network" {
  vpc_id = "${aws_vpc.network.id}"
  tags = "${var.tags}"
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.network.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.network.id}"
  }
  tags = "${merge(var.tags, map("Name", "${var.name}-public"))}"
}

resource "aws_route_table_association" "public" {
  count = "${length(var.zones)}"
  subnet_id = "${element(aws_subnet.network.*.id, count.index)}"
  route_table_id = "${aws_route_table.network.id}"
  tags = "${merge(var.tags, map("Name", "${var.name}-public"))}"
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.network.id}"
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_internet_gateway.network.id}"
  }
  tags = "${merge(var.tags, map("Name", "${var.name}-private"))}"
}

resource "aws_route_table_association" "private" {
  count = "${length(var.zones)}"
  subnet_id = "${element(aws_subnet.network.*.id, count.index)}"
  route_table_id = "${aws_route_table.network.id}"
  tags = "${merge(var.tags, map("Name", "${var.name}-private"))}"
}