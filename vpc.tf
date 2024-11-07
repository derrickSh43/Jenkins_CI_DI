//1. create the vpc
resource "aws_vpc" "dev_vpc" {
  cidr_block           = "10.230.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Dev VPC"
  }
}

//2.Create subnet put your AZ here

variable "vpc_availability_zone" {
  type        = list(string)
  description = "Availability zone"
  default     = ["us-east-1a", "us-east-1b"]
}

resource "aws_subnet" "front_public_subnet" {
  vpc_id            = aws_vpc.dev_vpc.id
  count             = length(var.vpc_availability_zone)
  cidr_block        = cidrsubnet(aws_vpc.dev_vpc.cidr_block, 8, count.index + 1)
  availability_zone = element(var.vpc_availability_zone, count.index)
  tags = {
    Name = "Custom Public Subnet${count.index + 1}",
  }
}
resource "aws_subnet" "web_private_subnet" {
  vpc_id            = aws_vpc.dev_vpc.id
  count             = length(var.vpc_availability_zone)
  cidr_block        = cidrsubnet(aws_vpc.dev_vpc.cidr_block, 8, count.index + 11)
  availability_zone = element(var.vpc_availability_zone, count.index)
  tags = {
    Name = "Custom Private Subnet${count.index + 1}",
  }
}
resource "aws_subnet" "BackEnd_private_subnet" {
  vpc_id            = aws_vpc.dev_vpc.id
  count             = length(var.vpc_availability_zone)
  cidr_block        = cidrsubnet(aws_vpc.dev_vpc.cidr_block, 8, count.index + 21)
  availability_zone = element(var.vpc_availability_zone, count.index)
  tags = {
    Name = "Custom Private Subnet${count.index + 1}",
  }
}


//3. Create internet gateway and attach it to the vpc

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "Custom Internet Gateway",
  }
}

//4. RT for the public subnet
resource "aws_route_table" "custom_route_table_public_subnet" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "Route Table for Public Subnet",
  }

}
//5. Association between RT and IG
resource "aws_route_table_association" "public_subnet_association" {
  route_table_id = aws_route_table.custom_route_table_public_subnet.id
  count          = length((var.vpc_availability_zone))
  subnet_id      = element(aws_subnet.front_public_subnet[*].id, count.index)
}



