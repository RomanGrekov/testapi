provider "aws" {
  region  = "${var.AWS_REGION}"
  profile = "boksinc"
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

variable "AWS_REGION" {
  default = "eu-central-1"
}

variable "AMIS" {
  type = "map"

  default = {
    eu-central-1 = "ami-0a8cd349f3bde8bc8"
  }
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "id_rsa.pub"
}
