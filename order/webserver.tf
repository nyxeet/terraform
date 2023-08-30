provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "web_server_web" {
  ami                    = "ami-0766f68f0b06ab145" # Amazon linux AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_server_security_group.id]

  tags = {
    Name  = "Order Web Server"
    Owner = "Dima"
  }

  depends_on = [aws_instance.web_server_app, aws_instance.web_server_db]
}
resource "aws_instance" "web_server_app" {
  ami                    = "ami-0766f68f0b06ab145" # Amazon linux AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_server_security_group.id]

  tags = {
    Name  = "Order App"
    Owner = "Dima"
  }

  depends_on = [aws_instance.web_server_db]
}
resource "aws_instance" "web_server_db" {
  ami                    = "ami-0766f68f0b06ab145" # Amazon linux AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_server_security_group.id]

  tags = {
    Name  = "Order DataBase"
    Owner = "Dima"
  }
}

resource "aws_security_group" "web_server_security_group" {
  name = "Order security group terraform"

  dynamic "ingress" {
    for_each = ["80", "443"]
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

  tags = {
    Name  = "Order security group"
    Owner = "Dima"
  }
}


