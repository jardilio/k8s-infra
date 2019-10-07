data "aws_availability_zones" "network" {}

resource "aws_vpc" "network" {
  cidr_block = "${var.cidr}"
  tags = "${
    merge(
        var.tags,
        map("kubernetes.io/cluster/${var.name}", "shared")
    )
  }"
}

resource "aws_subnet" "network" {
  count = "${var.azs}"
  availability_zone = "${element(data.aws_availability_zones.network.names, count.index)}"
  cidr_block = "TODO"
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

resource "aws_route_table" "network" {
  vpc_id = "${aws_vpc.network.id}"
  route {
    cidr_block = "${var.private ? var.cidr : "0.0.0.0/0"}"
    gateway_id = "${aws_internet_gateway.network.id}"
  }
  tags = "${var.tags}"
}

resource "aws_route_table_association" "cluster" {
  count = "${var.azs}"
  subnet_id = "${element(aws_subnet.network.*.id, count.index)}"
  route_table_id = "${aws_route_table.network.id}"
  tags = "${var.tags}"
}