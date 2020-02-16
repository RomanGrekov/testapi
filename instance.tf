provider "aws" {
  region = "${var.AWS_REGION}"
}

terraform {
  backend "s3" {
    bucket = "terraform-test-romang-1111"
    key    = "terraform/state"
    region = "eu-central-1"
  }
}

resource "aws_key_pair" "sshkey" {
  key_name   = "sshkey"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}

resource "aws_instance" "test" {
  ami           = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"
  key_name      = "${aws_key_pair.sshkey.key_name}"
}

resource "aws_security_group" "main" {
  name = "ssh_web"

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "AWS_REGION" {
  default = "eu-central-1"
}

variable "AMIS" {
  type = "map"

  default = {
    eu-central-1 = "ami-06021ed11a02d7d5e"
  }
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "id_rsa.pub"
}
