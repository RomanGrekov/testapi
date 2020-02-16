provider "aws" {
  region  = var.AWS_REGION
  profile = "boksinc"
}

terraform {
  backend "s3" {
    bucket = "terraform-test-romang-1111"
    key    = "terraform/state"
    region = "eu-central-1"
  }
}

module "vpc" {
    source = "./vpc_module"
    VPC_NAME = "test_vpc"
    AWS_REGION = var.AWS_REGION
}

resource "aws_security_group" "allow-ssh-web" {
    vpc_id = module.vpc.id
    name = "allow-ssh"

    ingress {
        from_port = "22"
        to_port = "22"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = "80"
        to_port = "80"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = "0"
        to_port = "0"
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "allo-ssh-sg"
    }
}
resource "aws_key_pair" "sshkey" {
  key_name   = "sshkey"
  public_key = file("${var.PATH_TO_PUBLIC_KEY}")
}

resource "aws_instance" "test" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.sshkey.key_name
  subnet_id = module.vpc.public-1-id
  vpc_security_group_ids = [aws_security_group.allow-ssh-web.id]

  connection {
    host = aws_instance.test.public_ip
    user        = "ubuntu"
    private_key = file("${var.PATH_TO_PRIVATE_KEY}")
  }


  provisioner "file" {
    source      = "api_server/server.py"
    destination = "/tmp/server.py"
  }

  #provisioner "remote-exec" {
#    inline = [
#      "sudo nohup python3 /tmp/server.py &",
#]
#}

  provisioner "local-exec" {
    command = "ssh -o 'StrictHostKeyChecking no' -i ${var.PATH_TO_PRIVATE_KEY} ubuntu@${aws_instance.test.public_ip} 'sudo nohup python3 /tmp/server.py </dev/null >/dev/null 2>&1 &'"
  }
}

variable "AWS_REGION" {
  default = "eu-central-1"
}

variable "AMIS" {
  default = {
    eu-central-1 = "ami-0a8cd349f3bde8bc8"
  }
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "id_rsa.pub"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "id_rsa"
}

output "public_ip" {
  value = aws_instance.test.public_ip
}
