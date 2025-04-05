provider "aws"{
    region = "us-east-1"
}

resource "aws_instance" "EC2_v1" {
    ami = "ami-00a929b66ed6e0de6" 
    instance_type = "t2.micro"
    key_name = "devops_keypair"
    security_groups = ["allow_ssh"]

    tags = {
        Name = "devops_project_server"
    }
}

resource "aws_security_group" "allow_ssh" {

    name = "allow_ssh"
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