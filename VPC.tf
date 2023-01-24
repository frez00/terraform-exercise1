terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version= "~> 4.16"
        }
    }

    required_version= ">=1.2.0"
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_vpc" "vpctahafore1" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "TahaVPCforeE1"
  }
}

resource "aws_subnet" "tahaspublicsubnetfore1" {
  vpc_id     = aws_vpc.vpctahafore1.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags = {
    Name = "TahapublicSNforE1"
  }
}

resource "aws_subnet" "tahasprivatesubnetfore1" {
  vpc_id     = aws_vpc.vpctahafore1.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "TahaprivateSNforE1"
  }
}

resource "aws_internet_gateway" "tahasigfore1" {
  vpc_id = aws_vpc.vpctahafore1.id

  tags = {
    Name = "TahasIGforE1"
  }
}

resource "aws_route_table" "tahasrtfore1" {
  vpc_id = aws_vpc.vpctahafore1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tahasigfore1.id
  }

  tags = {
    Name = "TahaRTforE1"
  }
}

resource "aws_route_table_association" "tahartafore1" {
  subnet_id      = aws_subnet.tahaspublicsubnetfore1.id
  route_table_id = aws_route_table.tahasrtfore1.id
}

resource "aws_nat_gateway" "tahangwfore1" {
  allocation_id = aws_eip.tahaeipfore1.id
  subnet_id     = aws_subnet.tahaspublicsubnet.id

  tags = {
    Name = "tahasnatgwinterraform"
  }
}

resource "aws_eip" "tahaeipfore1" {

    tags = {
        name = "TahasEIPforE1"
    }
}