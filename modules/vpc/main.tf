####################
#    Create VPC    #
####################
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "false"
  enable_classiclink   = "false"

  tags = {
    "Name" = "${var.project_name} ${var.vpc_cidr}"
  }
}

####################
#      Subnets     #
####################
#

/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name} InternetGateway"
  }
}


/* Elastic IP for NAT */
resource "aws_eip" "nat_eip" {
  vpc        = true
  count      = length(var.private_subnets_cidr)
  depends_on = [aws_internet_gateway.igw]
}

/* NAT */
resource "aws_nat_gateway" "nat_gateway" {
  count         = length(var.availability_zones)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.project_name} NATGW ${element(var.az_shortname, count.index)}"
  }
}

/* Public subnet */
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.availability_zones)
  cidr_block              = element(var.public_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name} Public ${element(var.az_shortname, count.index)}"
  }
}

/* Private subnet */
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.private_subnets_cidr)
  cidr_block              = element(var.private_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name} Isolation ${element(var.az_shortname, count.index)}"
  }
}

# resource "aws_vpc_peering_connection" "tooling_to_dev" {
#   peer_vpc_id = var.dev_accepter_vpc_id
#   vpc_id      = aws_vpc.vpc.id

#   requester {
#     allow_remote_vpc_dns_resolution = false
#   }

#   tags = {
#     Name = "tooling-pc-to-dev"
#   }
# }

# resource "aws_vpc_peering_connection" "tooling_to_qa" {
#   peer_vpc_id = var.qa_accepter_vpc_id
#   vpc_id      = aws_vpc.vpc.id

#   requester {
#     allow_remote_vpc_dns_resolution = false
#   }


#   tags = {
#     Name = "tooling-pc-to-qa"
#   }
# }

/* Routing table for private subnet */
resource "aws_route_table" "private_subnet_rtb" {
  count  = length(var.private_subnets_cidr)
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.project_name} Isolation ${element(var.az_shortname, count.index)}"
  }
}

/* Routing table for public subnet */
resource "aws_route_table" "public_subnet_rtb" {
  count  = length(var.public_subnets_cidr)
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.project_name} Public ${element(var.az_shortname, count.index)}"
  }
}

resource "aws_route" "igw" {
  count                  = length(var.public_subnets_cidr)
  route_table_id         = aws_route_table.public_subnet_rtb[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}


resource "aws_route" "nat_gw" {
  count                  = length(var.private_subnets_cidr)
  route_table_id         = aws_route_table.private_subnet_rtb[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway[count.index].id
}

/* Route table associations */
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_subnet_rtb[count.index].id
}
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private_subnet_rtb[count.index].id
}


######################################
##  VPC's Default Security Group
######################################

resource "aws_security_group" "private_vpc_sg" {
  name        = "${var.project_name} Isolation SG"
  description = "${var.project_name} Isolation SG"
  vpc_id      = aws_vpc.vpc.id


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

######################
##  VPC EndPoint S3 
######################
resource "aws_vpc_endpoint" "s3" {
  vpc_id          = aws_vpc.vpc.id
  service_name    = "com.amazonaws.ap-southeast-1.s3"
  route_table_ids = [aws_route_table.public_subnet_rtb[0].id, aws_route_table.public_subnet_rtb[1].id]
}
