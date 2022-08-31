resource "aws_vpc" "vpc" {
cidr_block = "${var.vpc_cidr}"
enable_dns_hostnames = "${var.dnshostname}"
tags = {
Name = "${var.vpc_name}"
}
}


data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public_subnet1" {
vpc_id = "${aws_vpc.vpc.id}"
cidr_block = "${var.public_subnet1_cidr}"
map_public_ip_on_launch = "${var.auto_publicip_assign}"
availability_zone = data.aws_availability_zones.available.names[0]
tags = {
Name = "${var.public_subnet1_name}"
}
}

resource "aws_subnet" "public_subnet2" {
vpc_id = "${aws_vpc.vpc.id}"
cidr_block = "${var.public_subnet2_cidr}"
map_public_ip_on_launch = "${var.auto_publicip_assign}"
availability_zone = data.aws_availability_zones.available.names[1]
tags = {
Name = "${var.public_subnet2_name}"
}
}

resource "aws_subnet" "private_subnet1" {
vpc_id = "${aws_vpc.vpc.id}"
cidr_block = "${var.private_subnet1_cidr}"
map_public_ip_on_launch = "false"
availability_zone = data.aws_availability_zones.available.names[0]
tags = {
Name = "${var.private_subnet1_name}"
}
}

resource "aws_subnet" "private_subnet2" {
vpc_id = "${aws_vpc.vpc.id}"
cidr_block = "${var.private_subnet2_cidr}"
map_public_ip_on_launch = "false"
availability_zone = data.aws_availability_zones.available.names[1]
tags = {
Name = "${var.private_subnet2_name}"
}
}
