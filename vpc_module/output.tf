output "id" {
    value = "${aws_vpc.main.id}"
}

output "public-1-id" {
    value = "${aws_subnet.public-1.id}"
}

output "public-2-id" {
    value = "${aws_subnet.public-2.id}"
}

output "public-3-id" {
    value = "${aws_subnet.public-3.id}"
}

output "private-1-id" {
    value = "${aws_subnet.private-1.id}"
}

output "private-2-id" {
    value = "${aws_subnet.private-2.id}"
}

output "private-3-id" {
    value = "${aws_subnet.private-3.id}"
}

output "private-1-az" {
    value = "${aws_subnet.private-1.availability_zone}"
}
