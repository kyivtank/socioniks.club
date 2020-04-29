variable "environment" {
}

variable "instance_type" {
}

variable "keyname" {
}

terraform {
  backend "s3" {
    bucket = "kyivtank-state"
    key    = "terraform/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
}

data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
    ami           = data.aws_ami.ubuntu.id
    instance_type   = var.instance_type
    key_name        = var.keyname
    vpc_security_group_ids = [aws_security_group.sg_allow_ssh_web.id]
    associate_public_ip_address = true
    tags = {
      Name = "Wordpress"
    }
}

resource "aws_security_group" "sg_allow_ssh_web" {
  name        = "allow_ssh_web"
  description = "Allow SSH and Web inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
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
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

output "PUBLIC_IP" {
  value = aws_instance.web.public_ip
}
