data "aws_availability_zones" "available" {}

resource "aws_vpc" "myVpc" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
  tags {
    Name = "mainVPC"
  }
}

resource "aws_subnet_pub1" "public_subnet1" {
  count = "${length(data.aws_availability_zones.available.names)}"
  vpc_id = "${aws_vpc.myVpc.id}"
  cidr_block = "10.1.128.0/20"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = true
  tags {
    Name = "PublicSubnet1"
  }
}

resource "aws_subnet_priv1" "private_subnet1" {
  count = "${length(data.aws_availability_zones.available.names)}"
  vpc_id = "${aws_vpc.myVpc.id}"
  cidr_block = "10.1.0.0/19"
  availability_zone= "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = false
  tags {
    Name = "PrivateSubnet1"
  }
}

resource "aws_subnet_pub2" "public_subnet2" {
  count = "${length(data.aws_availability_zones.available.names)}"
  vpc_id = "${aws_vpc.myVpc.id}"
  cidr_block = "10.1.128.0/20"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = true
  tags {
    Name = "PublicSubnet2"
  }
}

resource "aws_subnet_priv2" "private_subnet2" {
  count = "${length(data.aws_availability_zones.available.names)}"
  vpc_id = "${aws_vpc.myVpc.id}"
  cidr_block = "10.1.0.0/19"
  availability_zone= "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = false
  tags {
    Name = "PrivateSubnet2"
  }
}

resource "aws_subnet_pub3" "public_subnet3" {
  count = "${length(data.aws_availability_zones.available.names)}"
  vpc_id = "${aws_vpc.myVpc.id}"
  cidr_block = "10.1.128.0/20"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = true
  tags {
    Name = "PublicSubnet3"
  }
}

resource "aws_subnet_priv3" "private_subnet3" {
  count = "${length(data.aws_availability_zones.available.names)}"
  vpc_id = "${aws_vpc.myVpc.id}"
  cidr_block = "10.1.0.0/19"
  availability_zone= "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = false
  tags {
    Name = "PrivateSubnet3"
  }
}