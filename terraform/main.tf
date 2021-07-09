provider "aws" {
  region = var.region
}

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
      Name = "${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.subnet_1_cidr_block
  availability_zone = var.avail_zone
  tags = {
      Name = "${var.env_prefix}-subnet-1"
  }
}

resource "aws_internet_gateway" "myapp-igw" {
	vpc_id = aws_vpc.myapp-vpc.id
    
    tags = {
     Name = "${var.env_prefix}-internet-gateway"
   }
}

resource "aws_default_route_table" "main-rtb" {
    default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myapp-igw.id
    }
    tags = {
        Name = "${var.env_prefix}-main-rtb"
    }
}

resource "aws_security_group" "myapp-sg" {
    name = "myapp-sg"
    vpc_id = aws_vpc.myapp-vpc.id
    
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.my_ip,var.jenkins_ip]
    }
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
    }
    tags = {
        Name = "${var.env_prefix}-myapp-sg"
    }
}

data "aws_ami" "latest-ubuntu-image" {
    most_recent = true
    owners = ["099720109477"]
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}

output "aws_ami_id_ubuntu" {
    value = data.aws_ami.latest-ubuntu-image.id
}

resource "aws_instance" "build" {
    ami = data.aws_ami.latest-ubuntu-image.id
    instance_type = var.instance_type
    
    subnet_id = aws_subnet.myapp-subnet-1.id
    vpc_security_group_ids = [aws_security_group.myapp-sg.id]
    availability_zone = var.avail_zone

    associate_public_ip_address = true
    key_name = "myapp-key-pair"

    tags = {
        Name = "${var.env_prefix_1}-server"
    }
}
output "build-server" {
    value = aws_instance.build.public_ip
}

resource "aws_instance" "prod" {
    ami = data.aws_ami.latest-ubuntu-image.id
    instance_type = var.instance_type
    
    subnet_id = aws_subnet.myapp-subnet-1.id
    vpc_security_group_ids = [aws_security_group.myapp-sg.id]
    availability_zone = var.avail_zone

    associate_public_ip_address = true
    key_name = "myapp-key-pair"

    tags = {
        Name = "${var.env_prefix_2}-server"
    }
}
output "prod-server" {
    value = aws_instance.prod.public_ip
}