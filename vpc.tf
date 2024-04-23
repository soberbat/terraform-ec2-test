resource "aws_vpc" "test-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "vpc"
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.test-vpc.id

  tags = {
    Name = "test-gateway"
  }
}

resource "aws_route_table" "test" {
  vpc_id = aws_vpc.test-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
}

resource "aws_subnet" "test-subnet" {
  cidr_block              = "10.0.0.0/17"
  vpc_id                  = aws_vpc.test-vpc.id
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true

}


resource "aws_route_table_association" "associate" {
  subnet_id      = aws_subnet.test-subnet.id
  route_table_id = aws_route_table.test.id
}


resource "aws_instance" "web-server" {
  ami                         = "ami-0f673487d7e5f89ca"
  instance_type               = "t2.micro"
  availability_zone           = "eu-central-1a"
  subnet_id                   = aws_subnet.test-subnet.id
  key_name                    = "my-test-pair"
  associate_public_ip_address = true

  tags = {
    Name = "server"
  }
}


