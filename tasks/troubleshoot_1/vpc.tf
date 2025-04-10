resource "aws_vpc" "this_vpc" {
  cidr_block           = $var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_internet_gateway" "this_igw" {
  vpc_id = aws_vpc.this_vpc.id
}

resource "aws_route_table" "this_rt" {
  vpc_id = aws_vpc.this_vpc.id
}

resource "aws_route" "this_route" {
  route_table_id         = aws_route_table.this_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this_igw.id
}

resource "aws_route_table_association" "this_rt_association" {
  count          = length($var.subnet_cidrs)
  subnet_id      = element(aws_subnet.this_subnet.*.id, count.index)
  route_table_id = aws_route_table.this_rt.id

}

resource "aws_subnet" "this_subnet" {
  count = length($var.subnet_cidrs)

  cidr_block        = $var.subnet_cidrs[count.index]
  availability_zone = "us-east-1${element($var.availability_zones, count.index)}"
  vpc_id            = aws_vpc.this_vpc.id
}

resource "aws_security_group" "this_sg" {
  name        = "this_sg"
  description = "For test purposes"
  vpc_id      = aws_vpc.this_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.this_sg_ping]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "this_sg_ping" {
  name        = "this_sg_ping"
  description = "purposes"
  vpc_id      = aws_vpc.this_vpc.id

  ingress {
    from_port       = -1
    to_port         = -1
    protocol        = "icmp"
    security_groups = [aws_security_group.this_sg]
  }
}
