provider "aws" {

  region                      = "us-east-1"
  access_key                  = "fake"
  secret_key                  = "fake"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints   {
     ec2 = "http://localhost:4566"
  }
}


resource "aws_vpc" "my_new_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_new_vpc.id
}


resource "aws_subnet" "PublicSubnet" {
  vpc_id     = aws_vpc.my_new_vpc.id
  cidr_block = "10.0.0.0/24"
}

resource "aws_subnet" "PrivateSubnet" {
  vpc_id     = aws_vpc.my_new_vpc.id
  cidr_block = "10.0.1.0/24"
}


resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_new_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.PublicSubnet.id
  route_table_id = aws_route_table.public_route_table.id
}



resource "aws_security_group" "my_security_group" {
  name_prefix = "my-security-group"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "public_instance" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.PublicSubnet.id
  vpc_security_group_ids = ["${aws_security_group.my_security_group.id}"]
}
