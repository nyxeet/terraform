provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "web_server" {
  ami                    = "ami-0766f68f0b06ab145" # Amazon linux AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_server_security_group.id]
  user_data = templatefile("user-data.sh.tpl", {
    f_name = "Dima"
    l_name = "Kyrychenko"
    names  = ["Vasya", "Kolya", "Petya", "Joh", "Donald", "Masha"]
  })
  user_data_replace_on_change = true
  tags = {
    Name  = "Web Server Build by Terraform"
    Owner = "Dima"
  }
}

resource "aws_security_group" "web_server_security_group" {
  name        = "Web server security group terraform"
  description = "My first security group from terraform"

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
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Web Server SecurityGroup Build by Terraform"
    Owner = "Dima"
  }
}
