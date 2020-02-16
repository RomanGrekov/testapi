# Main VPC
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16" # 65000 IP addresses
    instance_tenancy = "default" # many instance can be on one phisical machine
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    tags = {
        Name = var.VPC_NAME
    }
}

# subnets
resource "aws_subnet" "public-1" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "${var.AWS_REGION}a"
    tags = {
        Name = "${var.VPC_NAME}-public-1"
    }
}

resource "aws_subnet" "public-2" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "${var.AWS_REGION}b"
    tags = {
        Name = "${var.VPC_NAME}-public-2"
    }
}

resource "aws_subnet" "public-3" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.3.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "${var.AWS_REGION}c"
    tags = {
        Name = "${var.VPC_NAME}-public-3"
    }
}

resource "aws_subnet" "private-1" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.4.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "${var.AWS_REGION}a"
    tags = {
        Name = "${var.VPC_NAME}-private-1"
    }
}

resource "aws_subnet" "private-2" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.5.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "${var.AWS_REGION}b"
    tags = {
        Name = "${var.VPC_NAME}-private-2"
    }
}

resource "aws_subnet" "private-3" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.6.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "${var.AWS_REGION}c"
    tags = {
        Name = "${var.VPC_NAME}-private-3"
    }
}

# Internet gateway
resource "aws_internet_gateway" "main-gw" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "${var.VPC_NAME}-gw"
    }
}

# Route tables
resource "aws_route_table" "main-public" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main-gw.id
    }

    tags = {
        Name = "${var.VPC_NAME}-public-1"
    }
}

# Route associations public
resource "aws_route_table_association" "public-1-a" {
    subnet_id = aws_subnet.public-1.id
    route_table_id = aws_route_table.main-public.id
}

resource "aws_route_table_association" "public-2-a" {
    subnet_id = aws_subnet.public-2.id
    route_table_id = aws_route_table.main-public.id
}

resource "aws_route_table_association" "public-3-a" {
    subnet_id = aws_subnet.public-3.id
    route_table_id = aws_route_table.main-public.id
}
