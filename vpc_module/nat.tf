# NAT gateway
resource "aws_eip" "nat" {
    vpc = "true"
}

resource "aws_nat_gateway" "nat-gw" {
    allocation_id = "${aws_eip.nat.id}"
    subnet_id = "${aws_subnet.public-1.id}"
    depends_on = ["aws_internet_gateway.main-gw"]
}

# VPC setup for NAT
resource "aws_route_table" "main-private" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.nat-gw.id}"
    }
    tags = {
        Name = "${var.VPC_NAME}-private-1"
    }
}

resource "aws_route_table_association" "private-1-a" {
    subnet_id = "${aws_subnet.private-1.id}"
    route_table_id = "${aws_route_table.main-private.id}"
}

resource "aws_route_table_association" "private-2-a" {
    subnet_id = "${aws_subnet.private-2.id}"
    route_table_id = "${aws_route_table.main-private.id}"
}

resource "aws_route_table_association" "private-3-a" {
    subnet_id = "${aws_subnet.private-3.id}"
    route_table_id = "${aws_route_table.main-private.id}"
}
