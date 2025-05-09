provider "aws"{
    region = "us-east-1"
}

resource "aws_instance" "dpp-ec2" {
    for_each = toset(["jenkins-master", "build-slave", "ansible"])
    ami = "ami-084568db4383264d4" 
    instance_type = "t2.micro"
    key_name = "devops_keypair"
    //security_groups = ["allow_ssh"]
    vpc_security_group_ids = each.key == "jenkins-master" ? [
        aws_security_group.dpp-sg.id, aws_security_group.dpp-jenkins-sg.id
    ] : [
        aws_security_group.dpp-sg.id
    ]

    subnet_id = aws_subnet.dpp-public-subnet-01.id
    tags = {
        Name = each.key
    }
}

resource "aws_security_group" "dpp-jenkins-sg"{
    name = "dpp-jenkins-sg"
    vpc_id = aws_vpc.dpp-vpc.id
    ingress{
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "dpp-sg" {

    name = "dpp-sg"
    vpc_id = aws_vpc.dpp-vpc.id
    ingress{
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_vpc" "dpp-vpc"{
    cidr_block = "10.1.0.0/16"
    tags = {
        Name = "dpp-vpc"
    }
}

resource "aws_subnet" "dpp-public-subnet-01"{
    vpc_id = aws_vpc.dpp-vpc.id
    cidr_block = "10.1.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1a"
    tags = {
        Name = "dpp-public-subnet-01"
    }
}

resource "aws_subnet" "dpp-public-subnet-02"{
    vpc_id = aws_vpc.dpp-vpc.id
    cidr_block = "10.1.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1b"
    tags = {
        Name = "dpp-public-subnet-02"
    }
}

resource "aws_internet_gateway" "dpp-igw"{
    vpc_id = aws_vpc.dpp-vpc.id
    tags = {
        Name = "dpp-igw"
    }
}

resource "aws_route_table" "dpp-public-rt"{
    vpc_id = aws_vpc.dpp-vpc.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.dpp-igw.id
    }
}

resource "aws_route_table_association" "dpp-rta-public-subnet-01"{
    subnet_id = aws_subnet.dpp-public-subnet-01.id
    route_table_id = aws_route_table.dpp-public-rt.id
}

resource "aws_route_table_association" "dpp-rta-public-subnet-02"{
    subnet_id = aws_subnet.dpp-public-subnet-02.id
    route_table_id = aws_route_table.dpp-public-rt.id
}