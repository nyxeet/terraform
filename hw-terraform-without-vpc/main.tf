provider "aws" {
  region = "eu-central-1"
}

resource "aws_security_group" "my_security_group" {
  name        = "hw terraform without vpc"
  description = "hw terraform without vpc"

  dynamic "ingress" {
    for_each = ["80", "443", "22", "3306"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_instance" {
  ami                    = "ami-0aa74281da945b6b5" # ami amazon linux 2
  instance_type          = "t2.micro"
  user_data              = file("bootstrap.sh")
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  tags = {
    Name  = "hw terraform without vpc"
    Owner = "Dima"
  }
}





